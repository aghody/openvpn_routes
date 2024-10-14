(For a Mac with OpenVPN)

I created this after all my IT support team could tell me to do is reboot and reinstall, while then default full VPN tunnel
contanstly dropped, completely imparing my ability to work from home or hold a meeting in zoom.

In my OpenVPN profile I added `route-nopull`.
nothing goes thru my VPN until I create a route for it.
(i.e. I manually created a split tunnel) and scripted dynamically updating the VPN routes.
There are ways the should work more easily, but after repeated attempts from within OpenVPN 
I resorted to this scripted method instead. 


`update_vpn.sh {fqdn} [remove]`  is way to dynamically add/remove FQDNs that will be routed thru the VPN tunnel interface.
The second script (`add_vpn_routes.sh`) will do the IP resolution.
By default it adds the fqdn passed to a file, "remove" is an optional parameter and should be self explanatory

`sudo add_vpn_routes.sh &` must be run as root in the backgroud ever 5 seconds and will read the intial and new additions to the FQDN list
(1) Resolve all IPv4s for the FQDNs in the FQDN list
(2) Checks if the routes already exist
(3) if not, add the routes to the Mac route table to the utun4 interface (my default tunnel interface when it is up)







