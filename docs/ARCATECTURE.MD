### Lease Database Updates
On Lease Change: The ISC DHCP server writes changes to the lease database file (dhcpd.leases) immediately when a lease is granted, renewed, or released. This means any change in lease status triggers an update to the file.
Periodic Writing: In addition to writing updates immediately on lease changes, the DHCP server also rewrites the entire lease database to a temporary file periodically. This process helps prevent the file from becoming fragmented over time with many expired leases. By default, this happens every hour, but this frequency can be configured.
Lease File Cleanup: After rewriting the lease file, the server replaces the old lease file with the new one to ensure that the file does not grow indefinitely with outdated lease records.




