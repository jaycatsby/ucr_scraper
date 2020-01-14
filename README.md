FBI Crime Data Explorer Scraper
===============================
This is a simple Python script that scrapes the U.S. arrest data by state and by agency using the Federal Bureau of Investigation's [Crime Data Explorer (CDE)](https://crime-data-explorer.fr.cloud.gov/) (API). I originally wrote this script for work to benchmark FBI's [Uniform Crime Reporting (UCR)](https://ucr.fbi.gov/) data against the data we have acquired at the [Criminal Justice Administrative Records System (CJARS)](https://cjars.isr.umich.edu/) at the University of Michigan (for current data holdings, see [here](https://cjars.isr.umich.edu/overview/research/data-documentation/summary-of-current-data-holdings/)). I'm assuming there might be similar codes out there but here is another one in case some one is looking for U.S. arrest data by offense type. So please use responsibly! :wink:

Output
------

The `run.py` file will save 3 different types of `.xlsx` files (~100 files altogether):
- `ucr_ori_crosswalk.xlsx`: Crosswalk of Agency ORI
    - API Endpoint: `'sapi/api/agencies'`
- `arrest_by_agency_*.xlsx`: Agency-level arrest data for each sate by offense type
    - API Endpoint: `'sapi/api/data/arrest/agencies/offense/{ori}/all/{min_yr}/{MAX_YEAR}'`
- `arrest_by_state_*.xlsx`: State-level arrest data by offense type
    - API Endpoint: `'sapi/api/data/arrest/states/offense/{state}/all/{min_yr}/{MAX_YEAR}'`

Install
-------
First, clone the repository:
```bash
$ git clone https://github.com/jaycatsby/ucr_scraper.git
```

Make sure you have all of the required packages (in `virtualenv` preferably):
```bash
$ pip install -r requirements.txt
```

Run
---
**Register**

If you haven'd done so already, sign up for an API Key: https://api.data.gov/signup/

**Edit `settings.py`**

- Set `API_KEY` in line 3 to what you received in the registration email (e.g.): `API_KEY = 'AGKQGIJPQEOJH!LNHPIJh31-9ujpfkn-h9h'`

- *(Optional)* Set `RAW_PATH`: By default, all of the data will be saved as `.xlsx` files in `raw` folder of the current directory.

- *(Optional)* Set `MIN_YEAR`: By default, starts from `1985`. I initially set this to `1975` to see if there would be differences in coverage but from my initial glance, most of the data seem to start in `1985`.

- *(Optional)* Set `MAX_YEAR`: Currently data up to `2018` is available. Edit as see fit.

- *(Optional)* Set `MAX_WORKERS`: **Please be responsible!** By default, set to use `2` processes


**Scrape**

After editing `settings.py`, run `run.py`
```bash
$ python run.py
```

Features
--------
- `Stata` Support: After scraping, run `clean_arrest.do` file to generate `*.dta` files of the arrest files in `./raw`
