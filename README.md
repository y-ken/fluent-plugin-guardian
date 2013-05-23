fluent-plugin-guardian
======================

Fluentd service to monitoring and automatic alerting suite.

## Notes

**Currently, it's a conceptual planning phase.**  
Please let me know the idea what you have wish to do.  
I'm waiting your message via Twitter or GitHub issues.

## Overview / Design

1. fluentd : collect various log data
2. fluent-plugin-guardian : monitoring status
  * check threshold (warn/crit)
  * check anomal sequential input
3. notify  
  works with fluentd plugins.  
  also support primary and secondary notify. (delayed notify with specific interval time)
  * [fluent-plugin-twilio](https://github.com/y-ken/fluent-plugin-twilio) : make a call with twilio
  * [fluent-plugin-jabber](https://github.com/todesking/fluent-plugin-jabber) : chat notification with XMPP(Jabber)
  * [fluent-plugin-hipchat](https://github.com/hotchpotch/fluent-plugin-hipchat) : HipChat notification
  * [fluent-plugin-mail](https://github.com/u-ichi/fluent-plugin-mail) : send a mail
  * [fluent-plugin-growl](https://github.com/takei-yuya/fluent-plugin-growl) : popup notification at your client computer
  * [fluent-plugin-twitter](https://github.com/y-ken/fluent-plugin-twitter) : tweet a sorry message to consumer
  * etc...

## Required middleware

* Redis (as storing persistent configuration)  
to store service list, server list and threshold of each.

* Fluentd (as flexible log aggregater)  
to collect application logs.

* Munin (as server monitoring backend)  
to fetch server load, memory, diskusage etc...

## Usage

#### Configuration

edit `td-agent.conf` / `fluentd.conf`

#### configure monitoring input

```
<match guardian.input.**>
  type guardian
  redis_server 127.0.0.1
  redis_port   6379
</match>
```

* tag sample
  * `guardian.input.server.<server>.<function>`  
  ex) guardian.collect.db-001.processlist
  * `guardian.input.app.<service>.<function>`  
  ex) guardian.app.ExampleWeb.forminputerror

#### configure notify service

You can use any fluentd output plugins.
tag name should be `guardian.notifier.<name>`.

```
<match guardian.notifier.twilio>
  type twilio
  account_sid TWILIO_ACCOUNT_SID
  auth_token  TWILIO_AUTH_TOKEN
  from_number +81312345678
</match>
```

#### Management

You can use cli tool named `guardian-cli`.  
The `guardian-cli` edit the configuration which stored at Redis.

```
# show all config
$ guardian-cli show config
$ guardian-cli show config service <service_name>
$ guardian-cli show config server <server_name>

# import config from json file
$ guardian-cli import <file_path>

# to add server
$ guardian-cli add server <ip> <name>

# to change threshold
$ guardian-cli set threshold <ip> <name>
```

#### Redis schema

TODO

## Articles

* Fluentdを用いたサービスの死活監視・電話通知等の自動化を行う、夢のプロダクト構想  
http://y-ken.hatenablog.com/entry/fluentd-monitoring-and-automatic-alerting-suite

## Contact
twitter: ([@yoshi_ken](https://twitter.com/yoshi_ken))
