local Bank = {
    getAccount = function(cb)
        ESX.TriggerServerCallback("bank:getAccount", function(data)
            local balance = 0
            local history = {}
            balance = tonumber(data.balance) or 0
            history = data.history
            cb({ balance = balance, history = history })
        end)
    end,

    syncAccount = function(self)
        self.getAccount(function(account)
            SendNUIMessage({
                type = "updateAccount",
                currentBalance = account.balance,
                history = account.history,
            })
        end)
    end,

    notify = function(message, typ)
        ESX.ShowNotification(message, typ)
    end,

    deposit = function(self, amount)
        ESX.TriggerServerCallback("bank:deposit", function(res)
            if res.ok then
                self:syncAccount()
            elseif res.message then
                self.notify(res.message, "error")
            end
        end, tonumber(amount))
    end,

    withdraw = function(self, amount)
        ESX.TriggerServerCallback("bank:withdraw", function(res)
            if res.ok then
                self:syncAccount()
            elseif res.message then
                self.notify(res.message, "error")
            end
        end, tonumber(amount))
    end,

    transfer = function(self, amount, target)
        ESX.TriggerServerCallback("bank:transfer", function(res)
            if res.ok then
                self:syncAccount()
            elseif res.message then
                self.notify(res.message, "error")
            end
        end, tonumber(amount), target)
    end,

    showBankUi = function(self, state)
        SetNuiFocus(state, state)
        if state then
            self.getAccount(function(account)
                SendNUIMessage({
                    type = "openBank",
                    state = true,
                    currentBalance = account.balance,
                    history = account.history,
                    currency = CURRENCY or "$",
                })
            end)
        else
            SendNUIMessage({
                type = "closeBank",
                state = false,
            })
        end
    end,
}

RegisterNetEvent("bank:updateHistory", function()
    Bank:syncAccount()
end)

local function DrawText3D(coords, text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)

    SetTextScale(0.0, 0.4)
    SetTextFont(4)
    SetTextCentre(true)
    SetTextOutline()

    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(0, 0)

    ClearDrawOrigin()
end

RegisterNUICallback("close", function(_, cb)
    Bank:showBankUi(false)
    cb("ok")
end)

RegisterNUICallback("deposit", function(data, cb)
    Bank:deposit(data.amount)
    cb("ok")
end)

RegisterNUICallback("withdraw", function(data, cb)
    Bank:withdraw(data.amount)
    cb("ok")
end)

RegisterNUICallback("transfer", function(data, cb)
    Bank:transfer(data.amount, data.target)
    cb("ok")
end)

RegisterNUICallback("notify", function(data, cb)
    Bank.notify(data.message, data.type)
    cb("ok")
end)

CreateThread(function()
    for _, bank in pairs(BANKS) do
        local model = joaat(bank.ped.model)

        RequestModel(model)

        while not HasModelLoaded(model) do
            Wait(0)
        end

        for _, location in pairs(bank.locations) do
            local coords = location.coords

            local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

            SetBlipSprite(blip, 161)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Bank")
            EndTextCommandSetBlipName(blip)

            local ped = CreatePed(
                4,
                model,
                coords.x,
                coords.y,
                coords.z - 1.0,
                location.heading,
                false,
                true
            )

            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)

            TaskStartScenarioInPlace(
                ped,
                "WORLD_HUMAN_CLIPBOARD",
                0,
                true
            )
        end

        SetModelAsNoLongerNeeded(model)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, bank in pairs(BANKS) do
            for _, location in pairs(bank.locations) do
                local distance = #(playerCoords - location.coords)

                if distance < 2.0 then
                    sleep = 0

                    DrawText3D(
                        location.coords + vec3(0.0, 0.0, 1.0),
                        bank.ped.text
                    )

                    if not USE_TARGET and IsControlJustReleased(0, 38) then
                        Bank:showBankUi(true)
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

if USE_TARGET then
    local registered = {}
    for _, bank in ipairs(BANKS) do
        local model = joaat(bank.ped.model)
        if not registered[model] then
            registered[model] = true
            exports.ox_target:addModel(model, {
                label = "Bank megnyitása",
                icon = "fa-solid fa-bank",
                onSelect = function()
                    Bank:showBankUi(true)
                end,
            })
        end
    end
end
