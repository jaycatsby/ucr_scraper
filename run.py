from settings import *
import multiprocessing
from tqdm import tqdm
import pandas as pd
import requests

manager = multiprocessing.Manager()
workers = manager.dict()

def get_ori_crosswalk(column_order):
    ori_xlsx = os.path.join(RAW_PATH, 'ucr_ori_crosswalk.xlsx')
    if not os.path.exists(ori_xlsx):
        print('Downloading UCR ORI Crosswalk\nThis may take a few minutes')
        resp = requests.get(ORI_URL).json()
        agencies = list()
        for state in tqdm(list(resp.keys()), bar_format='{desc:<5.5}{percentage:3.0f}%|{bar:10}{r_bar}'):
            state_data = resp[state]
            for ori in state_data.keys():
                agency_data = state_data[ori]
                agencies.append(agency_data)
        ori_df = pd.DataFrame(agencies)
        ori_df = ori_df[column_order]
        ori_df.sort_values(by=['state_abbr','ori'], inplace=True)
        ori_df.to_excel(ori_xlsx, index=False)
        print(f'Finished saving {ori_xlsx}')
        print(f'Found {len(ori_df)} agencies')
    else:
        ori_df = pd.read_excel(ori_xlsx)
        print(f'Finished loading {len(ori_df)} agencies')
    return ori_df

def generate_ori_queries(ori_df):
    queries = list()
    for state, df in ori_df.groupby(['state_abbr']):
        queries.append((state, df))
    return queries

def get_arrest_by_ori(state_abbr, df):
    worker = multiprocessing.current_process()
    worker_pid = worker.pid
    if worker_pid in workers.keys():
        worker_position = workers[worker_pid]
    else:
        if len(workers.keys())==0:
            workers[worker_pid] = 1
        else:
            workers[worker_pid] = len(workers.keys()) + 1
        worker_position = workers[worker_pid]

    ori_data = list()
    file = os.path.join(RAW_PATH, 'arrest_by_agency_{}.xlsx'.format(state_abbr.lower()))
    if not os.path.exists(file):
        oris = list(set(df['ori'].values))
        pbar = tqdm(oris, position=worker_position)
        for ori in pbar:
            for min_yr in range(MIN_YEAR, MAX_YEAR):
                url = f'https://api.usa.gov/crime/fbi/sapi/api/data/arrest/agencies/offense/{ori}/all/{min_yr}/{MAX_YEAR}?api_key={API_KEY}'
                resp = requests.get(url).json()
                if 'results' in resp.keys():
                    desc = f'({worker_position}) {worker_pid}: Found {ori} {min_yr}-{MAX_YEAR}'
                    pbar.set_description(desc)
                    arrest_data = resp['results']
                    for data in arrest_data:
                        data['ori'] = ori
                        ori_data.append(data)
                    break
                else:
                    continue
        ori_df = pd.DataFrame(ori_data)
        ori_df.to_excel(file, index=False)


def generate_state_queries(ori_df):
    return list(set(ori_df['state_abbr'].values))

def get_arrest_by_state(state_abbr):
    state = state_abbr.lower()
    worker = multiprocessing.current_process()
    worker_pid = worker.pid
    if worker_pid in workers.keys():
        worker_position = workers[worker_pid]
    else:
        if len(workers.keys())==0:
            workers[worker_pid] = 1
        else:
            workers[worker_pid] = len(workers.keys()) + 1
        worker_position = workers[worker_pid]

    STATE_ARREST_DATA = list()
    file = os.path.join(RAW_PATH, 'arrest_by_state_{}.xlsx'.format(state))
    if not os.path.exists(file):
        for min_yr in range(MIN_YEAR, MAX_YEAR):
            url = f'https://api.usa.gov/crime/fbi/sapi/api/data/arrest/states/offense/{state}/all/{min_yr}/{MAX_YEAR}?api_key={API_KEY}'
            resp = requests.get(url).json()
            if 'results' in resp.keys():
                state_data = resp['results']
                for data in state_data:
                    data['state_abbr'] = state
                    STATE_ARREST_DATA.append(data)
                break
            else:
                continue
        state_df = pd.DataFrame(STATE_ARREST_DATA)
        state_df.to_excel(file, index=False)
        print(f'Finished saving {file}')
    else:
        print(f'Skipped {state_abbr}')

if __name__=='__main__':
    ori_df = get_ori_crosswalk(ORI_XWALK_COLUMNS)
    ori_queries = generate_ori_queries(ori_df)

    print('Downloading state arrest data.\nThis will take shorter time than agency arrest data..')

    state_queries = generate_state_queries(ori_df)
    p = multiprocessing.Pool(MAX_WORKERS, initializer=tqdm.set_lock, initargs=(tqdm.get_lock(),))
    p.map(get_arrest_by_state, state_queries)
    p.terminate()
    p.join()

    print('Finished downloading state arrest data.')

    print('Downloading agency arrest data.\nThis will take some time!')

    multiprocessing.freeze_support()
    p = multiprocessing.Pool(MAX_WORKERS, initializer=tqdm.set_lock, initargs=(tqdm.get_lock(),))
    p.starmap(get_arrest_by_ori, ori_queries)
    p.terminate()
    p.join()
