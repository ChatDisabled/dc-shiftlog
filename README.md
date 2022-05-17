# dc-shiftlog

This was requested since [this one](https://github.com/Re2team/qb-shiftlog) "didn't work" properly.
I present you a shift log resource which doesn't handout your Discord webhooks for free 🥳. Testing and issues are appreciated.
But should work as intended.

## How do I setup logs?

As you might have noticed from the `CreateLog` function in `server.lua` there are some predefined jobs with each triggering their own qb-log trigger
https://github.com/Disabled-Coding/dc-shiftlog/blob/e455c5f3d08ef0e38d932aa8388b240c6c4160ee/server.lua#L22
https://github.com/Disabled-Coding/dc-shiftlog/blob/e455c5f3d08ef0e38d932aa8388b240c6c4160ee/server.lua#L26
https://github.com/Disabled-Coding/dc-shiftlog/blob/e455c5f3d08ef0e38d932aa8388b240c6c4160ee/server.lua#L30
You can add as many job specific triggers as you want and add them to your QBCore log recourse. At the time of writing you can find this inside of `qb-smallresources/server/logs.lua`. And add the following lines with the other webhooks you have setup.
```
    ['shiftlogPolice'] = '',
    ['shiftlogAmbulance'] = '',
    ['shiftlogRealestate'] = '',
```
#### Be aware! The above is case sensitive.

You can always find support [here](https://discord.gg/SqRsSsSskg) in our Discord.
### Donations are **greatly** appreciated
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/N4N4BE29E)

![image](https://cdn.discordapp.com/attachments/967850345306914826/975170280198647908/unknown.png)
