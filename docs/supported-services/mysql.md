[comment]: # (Do not edit this file as it is autogenerated. Go to docs/individual-docs if you want to make edits.)


[comment]: # (Please add your documentation on top of this line)

## services\.mysql\.enable

Whether to enable MySQL process and expose utilities\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## services\.mysql\.package



Which package of MySQL to use



*Type:*
package



*Default:*
` pkgs.mariadb `



## services\.mysql\.ensureUsers



Ensures that the specified users exist and have at least the ensured permissions\.
The MySQL users will be identified using Unix socket authentication\. This authenticates the Unix user with the
same name only, and that without the need for a password\.
This option will never delete existing users or remove permissions, especially not when the value of this
option is changed\. This means that users created and permissions assigned once through this option or
otherwise have to be removed manually\.



*Type:*
list of (submodule)



*Default:*
` [ ] `



*Example:*

```
[
  {
    name = "devenv";
    ensurePermissions = {
      "devenv.*" = "ALL PRIVILEGES";
    };
  }
]

```



## services\.mysql\.ensureUsers\.\*\.ensurePermissions



Permissions to ensure for the user, specified as attribute set\.
The attribute names specify the database and tables to grant the permissions for,
separated by a dot\. You may use wildcards here\.
The attribute values specfiy the permissions to grant\.
You may specify one or multiple comma-separated SQL privileges here\.
For more information on how to specify the target
and on which privileges exist, see the
[GRANT syntax](https://mariadb\.com/kb/en/library/grant/)\.
The attributes are used as ` GRANT ${attrName} ON ${attrValue} `\.



*Type:*
attribute set of string



*Default:*
` { } `



*Example:*

```
{
  "database.*" = "ALL PRIVILEGES";
  "*.*" = "SELECT, LOCK TABLES";
}

```



## services\.mysql\.ensureUsers\.\*\.name



Name of the user to ensure\.



*Type:*
string



## services\.mysql\.ensureUsers\.\*\.password



Password of the user to ensure\.



*Type:*
null or string



*Default:*
` null `



## services\.mysql\.importTimeZones



Whether to import tzdata on the first startup of the mysql server



*Type:*
null or boolean



*Default:*
` null `



## services\.mysql\.initialDatabases



List of database names and their initial schemas that should be used to create databases on the first startup
of MySQL\. The schema attribute is optional: If not specified, an empty database is created\.



*Type:*
list of (submodule)



*Default:*
` [ ] `



*Example:*

```
[
  { name = "foodatabase"; schema = ./foodatabase.sql; }
  { name = "bardatabase"; }
]

```



## services\.mysql\.initialDatabases\.\*\.name



The name of the database to create\.



*Type:*
string



## services\.mysql\.initialDatabases\.\*\.schema



The initial schema of the database; if null (the default),
an empty database is created\.



*Type:*
null or path



*Default:*
` null `



## services\.mysql\.settings



MySQL configuration\.



*Type:*
lazy attribute set of lazy attribute set of anything



*Default:*
` { } `



*Example:*

```
{
  mysqld = {
    key_buffer_size = "6G";
    table_cache = 1600;
    log-error = "/var/log/mysql_err.log";
    plugin-load-add = [ "server_audit" "ed25519=auth_ed25519" ];
  };
  mysqldump = {
    quick = true;
    max_allowed_packet = "16M";
  };
}

```



## services\.mysql\.useDefaultsExtraFile



Whether to use defaults-exta-file for the mysql command instead of defaults-file\.
This is useful if you want to provide a config file on the command line\.
However this can problematic if you have MySQL installed globaly because its config might leak into your environment\.
This option does not affect the mysqld command\.



*Type:*
boolean



*Default:*
` false `