- https://docs.github.com/en/enterprise-server@3.14/admin/upgrading-your-instance/preparing-to-upgrade/enabling-automatic-update-checks
- take snapshot https://docs.github.com/en/enterprise-server@3.14/admin/upgrading-your-instance/preparing-to-upgrade/taking-a-snapshot

### Enabled automatic update checks

- ![Screenshot of the header of the Management Console. A tab, labeled ](https://docs.github.com/assets/cb-32839/images/enterprise/management-console/updates-tab.png)

### Hotpatch

- If a hotpatch is available for an upgrade, the `.hpkg` will download automatically. In the management console you can choose to install the hotpatch immediately or schedule installation for a later time. For more information, see "[Upgrading with a hotpatch](https://docs.github.com/en/enterprise-server@3.14/admin/upgrading-your-instance/performing-an-upgrade/upgrading-with-a-hotpatch)."

### Upgrade package

- When an upgrade package is automatically downloaded for your GitHub Enterprise Server instance, you'll receive a message letting you know you can upgrade GitHub Enterprise Server. Packages download to the `/var/lib/ghe-updates` directory on your GitHub Enterprise Server instance. For more information about the recommendations and requirements for upgrades, see "[Overview of the upgrade process](https://docs.github.com/en/enterprise-server@3.14/admin/upgrading-your-instance/preparing-to-upgrade/overview-of-the-upgrade-process)."
