# k9 Security Splunk Integration
This repo contains the k9 Security Splunk integration tools.

These tools help you load the k9 Security csv files into Splunk for viewing in the k9 Security dashboard:
![k9 Security Splunk Dashboard](assets/k9security-dashboard.png)

The tools include:

* k9security.bash - shell convenience functions (customer changes required) 
* stage-k9security-data-for-ingest.sh - a script to stage recent files (7d) for import  

These tools currently populate a local Splunk installation running in Docker.  You can load
into a production Docker installation by replacing the `docker cp` to the Splunk spool directory
with `cp` to your own spool directory.

## Dependencies

* bash shell
* aws cli
* credentials providing access to your k9 Security reports bucket

Then you will need to configure several entities in Splunk:

###`k9_security_analysis:csv` Source Type

Define the `k9_security_analysis:csv` Source Type:

```ini
[k9_security_analysis:csv]
BREAK_ONLY_BEFORE_DATE =
DATETIME_CONFIG =
INDEXED_EXTRACTIONS = csv
KV_MODE = none
LINE_BREAKER = ([\r\n]+)
NO_BINARY_CHECK = true
SHOULD_LINEMERGE = false
TIMESTAMP_FIELDS = analysis_time
TIME_FORMAT = %Y-%m-%dT%H:%M:%S.%6N%:z
TZ = GMT
category = Structured
description = k9 Security principals data in v1 csv format.
disabled = false
pulldown_type = 1
```

### `k9_security` Index

Define the `k9_security` index, e.g. in `/opt/splunk/etc/apps/search/local/indexes.conf`:

```ini
[k9_security]
coldPath = $SPLUNK_DB/k9_security/colddb
enableDataIntegrityControl = 0
enableTsidxReduction = 0
```

### Directory Monitoring Input 
Define a directory monitoring input using the previously-defined index and sourcetype, e.g.:

```ini 
[monitor:///var/local/splunk-inputs/k9security]
disabled = false
host = k9-security
index = k9_security
sourcetype = k9_security_analysis:csv
```

### k9 Daily Review Dashboard

Create a `k9 Daily Review` dashboard ([source](k9_daily_review.dashboard.xml)).

Now populate the `k9_security` index with k9 csv report data.

## Populating

1. Update the k9security.bash file with the name of the bucket containing k9 Security reports and your customer id
2. Load `k9security.bash` into your shell with `source k9security.bash`
3. Execute `sync-k9security-inbox` in your shell; this command synchronizes reports in s3 `~/tmp/k9security-inbox/` with `aws sync`
4. Execute `./stage-k9security-data-for-ingest.sh`
