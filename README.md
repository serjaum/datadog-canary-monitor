# Datadog check monitors

This tool can help you to integrate any service/tool/system to check datadog monitors. It can help you to make decisions before continue a canary deployment for example

You can use multiple monitors in any pipeline. If any monitor fails, the container will exit with failure


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
ruby
docker
datadog api and app keys
```

### How to run the app

Export env vars

```
export DATADOG_APP_KEY="1a2b3c4d"
export DATADOG_API_KEY="1a2b3c4d"
export DATADOG_MONITORS_ID="id_monitor_1,id_monitor_2,...,id_monitor_n"
export CANARY_CHECK_RULE="<AND or OR>"
```

Run the script

```
ruby datadog.rb
```

### How to run the container

Build the docker image

```
docker build -t hue .
```

Run the container

```
docker run -e DATADOG_MONITORS_ID="id_monitor_1,id_monitor_2,...,id_monitor_n" \
           -e CANARY_CHECK_RULE="and" \
           -e DATADOG_API_KEY="1a2b3c4d" \
           -e DATADOG_APP_KEY="1a2b3c4d" \
           hue
```

### Output

```
[OK] - 19994230 => Canary Check - Error Ratio
[OK] - 19994313 => Canary Check - Error rate
[OK] - 19994101 => Canary Check - Latency
[OK] - 19994381 => Canary Check - Pods memory usage
[OK] - 19994128 => Canary Check - Request errors
[OK] - 19994393 => Canary Check
------
OK
```

## The rules

AND = All monitors needs to be OK

OR = If one or more monitors fails, the app will not fail, except if all of the monitors fails

## Kubernetes

WIP
