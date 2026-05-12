function CreateSQL(name)
    local p = promise.new()

    local exists = MySQL.scalar.await("SHOW TABLES LIKE '" .. name .. "'")
    if exists then
        return p:resolve(false)
    end

    MySQL.query([[
			CREATE TABLE IF NOT EXISTS `bank_history` (
				`id` INT(11) NOT NULL AUTO_INCREMENT,
				`identifier` VARCHAR(255) NOT NULL,
				`amount` INT(11) NOT NULL,
				`type` VARCHAR(255) NOT NULL,
				`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
				PRIMARY KEY (`id`)
			)
		]], function()
        p:resolve(true)
    end)

    return p
end

CreateThread(function()
    Wait(1000)
    CreateSQL("bank_history")
end)

function UpdateHistory(playerId, amount, type)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        MySQL.insert("INSERT INTO `bank_history` (`identifier`, `amount`, `type`) VALUES (?, ?, ?)", {
            xPlayer.identifier,
            amount,
            type
        })
        TriggerClientEvent("bank:updateHistory", xPlayer.source, amount, type)
    end
end

ESX.RegisterServerCallback("bank:getAccount", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb({ balance = 0, history = {} })
        return
    end

    local balance = xPlayer.getAccount("bank").money
    local history = MySQL.query.await("SELECT * FROM `bank_history` WHERE `identifier` = ?", {
        xPlayer.identifier,
    }) or {}

    if type(history) ~= "table" then
        history = {}
    end

    cb({
        balance = balance,
        history = history,
    })
end)

ESX.RegisterServerCallback("bank:deposit", function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    amount = math.floor(tonumber(amount) or 0)

    if not xPlayer or amount <= 0 then
        return cb({
            ok = false,
            message = "Érvénytelen összeg."
        })
    end

    if xPlayer.getMoney() < amount then
        return cb({
            ok = false,
            message = "Nincs elég készpénzed!"
        })
    end

    xPlayer.removeMoney(amount)
    xPlayer.addAccountMoney("bank", amount)

    UpdateHistory(xPlayer.source, amount, "deposit")

    cb({
        ok = true,
        balance = xPlayer.getAccount("bank").money
    })
end)

ESX.RegisterServerCallback("bank:withdraw", function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    amount = math.floor(tonumber(amount) or 0)

    if not xPlayer or amount <= 0 then
        return cb({
            ok = false,
            message = "Érvénytelen összeg."
        })
    end

    if xPlayer.getAccount("bank").money < amount then
        return cb({
            ok = false,
            message = "Nincs elég fedezet a számládon!"
        })
    end

    xPlayer.removeAccountMoney("bank", amount)
    xPlayer.addMoney(amount)

    UpdateHistory(xPlayer.source, amount, "withdraw")

    cb({
        ok = true,
        balance = xPlayer.getAccount("bank").money
    })
end)

ESX.RegisterServerCallback("bank:transfer", function(source, cb, amount, targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(tonumber(targetId))

    amount = math.floor(tonumber(amount) or 0)

    if not xPlayer or not xTarget or amount <= 0 or xTarget.source == source then
        return cb({
            ok = false,
            message = "Érvénytelen tranzakció."
        })
    end

    if xPlayer.getAccount("bank").money < amount then
        return cb({
            ok = false,
            message = "Nincs elég fedezet a számládon!"
        })
    end

    xPlayer.removeAccountMoney("bank", amount)
    xTarget.addAccountMoney("bank", amount)

    UpdateHistory(xPlayer.source, amount, "transfer")

    UpdateHistory(xTarget.source, amount, "transfer_received")

    cb({
        ok = true,
        balance = xPlayer.getAccount("bank").money
    })
end)
