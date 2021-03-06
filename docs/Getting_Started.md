# F5 Automation Toolchain Workshop

## Getting Started

This workshop is intended to give more inside in the use of F5 Automation Toolchain and uses Terraform to deploy infrastructure, BIG-IPs and backends automatically in Azure public cloud.

F5 Automation Toolchain delivers that a BIG-IP can be turned into code and deployed in a declarative and automated way to provide L4- L7 application services. 

When you are not familiar with F5 automation Toolchain, please go to: https://clouddocs.f5.com/  and start reading.

Those who already have done the introduction to Automation & Orchestration aka supernetops training are invited to use this workshop to gain more understanding of the entire toolchain F5 has developed.


## Starting with UDF

When you are an F5 employee, select the “F5 EMEA Automation Toolchain Workshop” from the UDF Blueprint section and start deploying.
When you are invited by F5 into this workshop, you will get an invition by email and through UDF classroom will be able to launch the blueprint.
The student will find that a resource_group **‘student<number>-f5-atc-workshop’** and location **‘West Europe’** is already configured in Azure.
During the workshop which uses UDF, this is done for you. Once getting invited this resource group is there with the right location. Terraform will create its infrastructure here.

```
Note:
Please refresh the Azure creds before deploying through Terraform. Location of the creds are in /home/file/tmp.yml. When you got invited for this UDF lab, this is done for you.
```

## Starting the lab without UDF

When you don't have access to a UDF lab enviroment or simply want to use the lab without. Please follow the instructions which can be found in Task1_0. (clicking two times **Next** from here)

## How things work (both UDF and non-UDF)
The lab starts with cloning the Github repo and after this you need to create the setup.yml before the environment can be started through Terraform.
When Terraform starts deploying the infrastructure as shown in the network diagram, all dynamic allocated IP addresses and nesecarry values from Azure will get collected in "F5_ATC_EMEA_Partner_Workshop_postman_environment.json" which can be found in the directory /postman after Terraform has finished the deployement. Some of those values are also published as output in Terraform which can be used later on as a reference.

The deployed infrastructure consists out of:
 * Two separate BIG-IPs
 * Two webservers
 * One DVWA-server

All written exercises will be using F5 automation toolchain and it is expected that you will use Postman to deploy and explore. Only the first FAST labs will ask you to use the BIG-IP GUI, but this is on purpose.

![](png/getting_started/network_diagram.png)


![](png/getting_started/workshop_overview_table.png)

[PREVIOUS](../README.md)      [NEXT](module_1/module1.md)