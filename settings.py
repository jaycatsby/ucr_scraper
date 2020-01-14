import os

API_KEY = os.environ['DATA_GOV_API_KEY']

CURR_PATH = os.getcwd()

RAW_PATH = os.path.join(CURR_PATH, 'raw')
if not os.path.exists(RAW_PATH):
    os.mkdir(RAW_PATH)

MIN_YEAR = 1985

MAX_YEAR = 2018

MAX_WORKERS = 2

# URLS
ORI_URL = f'https://api.usa.gov/crime/fbi/sapi/api/agencies?api_key={API_KEY}'

# Column Order of ucr_ori_crosswalk.xlsx
ORI_XWALK_COLUMNS = [
    'state_abbr', 'state_name', 'ori',
    'agency_name', 'agency_type_name',
    'county_name', 'region_desc', 'region_name',
    'division_name', 'latitude', 'longitude',
    'nibrs', 'nibrs_start_date'
]
