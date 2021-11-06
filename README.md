Role Name
=========
This role installs anyconnect and optionally installs onguard,
crowdstrike and lansweeper from installer files downloaded from S3 or already
existing on the host.

Read defaults/main.yml to understand option overrides

Requirements
------------
aws cli is required for this role. The tests use a public role to install awscli_v2


Example Playbook
----------------

The three are required to download the installers from an S3 bucket. Read
defaults/main.yml for more options

    - hosts: servers
      roles:
        - role: natemarks.anyconnect
          vars:
            aws_access_key_id: {{ aws_access_key_id }}
            aws_secret_access_key: {{ aws_secret_access_key }}
            download_bucket: {{ s3_bucket }}
  

License
-------

MIT

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
