local regui = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'
    )
)()

local prompt = regui
    :Window({
        Title = 'Sorry..',
        Size = UDim2.fromOffset(300, 125),
        NoCollapse = true,
        NoResize = true,
        NoScroll = true,
    })
    :Center()
prompt:Label({
    Text = 'This script is currently detected, it is being worked on to mitigate the detections. Join the discord for updates (SOON)',
    TextWrapped = true,
})
prompt:Separator()
prompt:Label({
    Text = 'discord.gg/VSKCM7rXVY',
})

task.wait(3)
game.Players.LocalPlayer:Kick("Join the discord to be notified when this is undetected; discord.gg/VSKCM7rXVY")
