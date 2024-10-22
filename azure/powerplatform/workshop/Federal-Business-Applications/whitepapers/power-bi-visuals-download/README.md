# Power BI Visuals Bulk Download
For customers that need to download Power BI visuals from the marketplace to use in disconnected environments, we have created a PowerShell script that can be run on a internet connected machine, and then transfer the visuals to a disconnected environment for use with Power BI Report Server.

NOTE:  Not all custom visuals in the market place work with Power BI Report Server.  Specifically, any custom visuals written in R will not work.

## Setup
You can get the full PowerShell script below,

[Visuals Bulk Download PowerShell Script](files/VisualsBulkDownloadTool.ps1)

You can also watch a YouTube video on how to use this script as well,

[Using Power BI AppSource Visuals in Disconnected Environments](https://youtu.be/JRDc9kyAmeo)

When you run the script you have some optional flags,

* This script will download all Power BI visuals from the marketplace and save them to a downloads subfolder in the current working directory.
* You can optionally specify the ```-CertifiedOnly``` switch to only download visuals that have gone through the certification process.
* You can optionally specify the ```-MicrosoftOnly``` switch to download visuals that are created by Microsoft.
