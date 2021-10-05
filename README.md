# k9 Security Splunk Integration
This repo contains the k9 Security Splunk integration tools.

These tools help you load the k9 Security csv files into Splunk for viewing in the k9 Security dashboard:
![k9 Security Splunk Dashboard](assets/k9security-dashboard.png)

The tools include:

* k9security.bash - shell convenience functions (customer changes required) 
* stage-k9security-data-for-ingest.sh - a script to stage recent files for import  

These tools currently populate a local Splunk installation running in Docker.  You can load
into a production Docker installation by replacing the `docker cp` to the Splunk spool directory
with `cp` to your own spool directory.

## Dependencies:
* bash shell
* aws cli
* credentials providing access to your k9 Security reports bucket

## Populating

1. Update the k9security.bash file with the name of the bucket containing k9 Security reports and your customer id
2. Load `k9security.bash` into your shell with `source k9security.bash`
3. Execute `sync-k9security-inbox` in your shell; this command synchronizes reports in s3 `~/tmp/k9security-inbox/` with `aws sync`
4. Execute `./stage-k9security-data-for-ingest.sh`
