local QBCore = exports['qb-core']:GetCoreObject()

-- Initialiser la base de données au démarrage
AddEventHandler('onServerStart', function()
    InitializeCompanies()
    TriggerEvent('company:startPayroll')
end)

-- ===============================
-- COMMANDES ADMIN
-- ===============================

-- Créer un job (admin only)
QBCore.Commands.Add('createjob', 'Créer un nouveau job', {}, false, function(source, args, rawCommand)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    if not player.PlayerData.job.isboss then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Vous n\'êtes pas autorisé'}})
    end
    
    if #args < 2 then
        return TriggerClientEvent('chat:addMessage', src, {args = {'INFO', 'Usage: /createjob [nom] [label]'}})
    end
    
    local jobName = args[1]:lower()
    local jobLabel = args[2]
    
    -- Ajouter la logique pour créer un job ici
    TriggerClientEvent('chat:addMessage', src, {args = {'SUCCÈS', 'Job créé: ' .. jobName}})
end, 'admin')

-- Définir un boss (admin only)
QBCore.Commands.Add('setboss', 'Définir un boss pour une entreprise', {}, false, function(source, args, rawCommand)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    -- Vérifier que c'est un admin
    if player.PlayerData.group ~= 'admin' then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Vous n\'êtes pas autorisé'}})
    end
    
    if #args < 2 then
        return TriggerClientEvent('chat:addMessage', src, {args = {'INFO', 'Usage: /setboss [company] [playerId]'}})
    end
    
    local company = args[1]:lower()
    local targetId = tonumber(args[2])
    
    if not Config.Companies[company] then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Entreprise inconnue'}})
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not targetPlayer then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Joueur introuvable'}})
    end
    
    AddCompanyBoss(company, targetPlayer.PlayerData.citizenid, targetPlayer.PlayerData.charinfo.firstname .. ' ' .. targetPlayer.PlayerData.charinfo.lastname)
    
    TriggerClientEvent('chat:addMessage', src, {args = {'SUCCÈS', targetPlayer.PlayerData.charinfo.firstname .. ' est maintenant boss de ' .. company}})
    TriggerClientEvent('chat:addMessage', targetId, {args = {'INFO', 'Vous êtes devenu boss de ' .. company}})
end, 'admin')

-- Définir un propriétaire (admin only)
QBCore.Commands.Add('setowner', 'Définir le propriétaire d\'une entreprise', {}, false, function(source, args, rawCommand)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    if player.PlayerData.group ~= 'admin' then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Vous n\'êtes pas autorisé'}})
    end
    
    if #args < 2 then
        return TriggerClientEvent('chat:addMessage', src, {args = {'INFO', 'Usage: /setowner [company] [playerId]'}})
    end
    
    local company = args[1]:lower()
    local targetId = tonumber(args[2])
    
    if not Config.Companies[company] then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Entreprise inconnue'}})
    end
    
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    if not targetPlayer then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Joueur introuvable'}})
    end
    
    SetCompanyOwner(company, targetPlayer.PlayerData.citizenid, targetPlayer.PlayerData.charinfo.firstname .. ' ' .. targetPlayer.PlayerData.charinfo.lastname)
    
    TriggerClientEvent('chat:addMessage', src, {args = {'SUCCÈS', targetPlayer.PlayerData.charinfo.firstname .. ' est maintenant propriétaire de ' .. company}})
    TriggerClientEvent('chat:addMessage', targetId, {args = {'INFO', 'Vous êtes devenu propriétaire de ' .. company}})
end, 'admin')

-- Retirer un employé (boss/owner only)
QBCore.Commands.Add('fireemployee', 'Licencier un employé', {}, false, function(source, args, rawCommand)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job.name
    
    if not (IsPlayerBoss(playerJob, player.PlayerData.citizenid) or IsPlayerOwner(playerJob, player.PlayerData.citizenid)) then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Vous n\'avez pas les permissions'}})
    end
    
    if #args < 1 then
        return TriggerClientEvent('chat:addMessage', src, {args = {'INFO', 'Usage: /fireemployee [playerId]'}})
    end
    
    local targetId = tonumber(args[1])
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    
    if not targetPlayer then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Joueur introuvable'}})
    end
    
    RemoveEmployee(playerJob, targetPlayer.PlayerData.citizenid)
    
    TriggerClientEvent('chat:addMessage', src, {args = {'SUCCÈS', targetPlayer.PlayerData.charinfo.firstname .. ' a été licencié'}})
    TriggerClientEvent('chat:addMessage', targetId, {args = {'ERREUR', 'Vous avez été licencié'}})
end, 'user')

-- ===============================
-- ÉVÉNEMENTS
-- ===============================

-- Récupérer les données d'une entreprise
RegisterNetEvent('company:getCompanyData')
AddEventHandler('company:getCompanyData', function(company)
    local src = source
    local data = GetCompanyData(company)
    TriggerClientEvent('company:receiveCompanyData', src, data)
end)

-- Ouvrir la tablette
RegisterNetEvent('company:openTablet')
AddEventHandler('company:openTablet', function(company)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local companyData = GetCompanyData(company)
    
    if not (IsPlayerBoss(company, player.PlayerData.citizenid) or IsPlayerOwner(company, player.PlayerData.citizenid)) then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Vous n\'avez pas accès à la tablette'}})
    end
    
    TriggerClientEvent('company:showTablet', src, companyData)
end)

-- Proposer un contrat
RegisterNetEvent('company:proposeContract')
AddEventHandler('company:proposeContract', function(targetId, company)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local targetPlayer = QBCore.Functions.GetPlayer(targetId)
    
    if not (IsPlayerBoss(company, player.PlayerData.citizenid) or IsPlayerOwner(company, player.PlayerData.citizenid)) then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Vous n\'avez pas les permissions'}})
    end
    
    if not targetPlayer then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Joueur introuvable'}})
    end
    
    TriggerClientEvent('company:receiveContract', targetId, {
        from = player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname,
        company = company,
        companylabel = Config.Companies[company].label,
        source = src
    })
end)

-- Accepter un contrat
RegisterNetEvent('company:acceptContract')
AddEventHandler('company:acceptContract', function(company, recruiterSource)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    if IsPlayerEmployee(company, player.PlayerData.citizenid) then
        return TriggerClientEvent('chat:addMessage', src, {args = {'ERREUR', 'Vous travaillez déjà pour cette entreprise'}})
    end
    
    AddEmployee(company, player.PlayerData.citizenid, player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname, 'employee')
    
    TriggerClientEvent('chat:addMessage', src, {args = {'SUCCÈS', 'Contrat accepté! Vous êtes maintenant employé de ' .. GetCompanyLabel(company)}})
    TriggerClientEvent('chat:addMessage', recruiterSource, {args = {'INFO', player.PlayerData.charinfo.firstname .. ' a accepté le contrat'}})
end)

-- Refuser un contrat
RegisterNetEvent('company:rejectContract')
AddEventHandler('company:rejectContract', function(recruiterSource, firstname, lastname)
    TriggerClientEvent('chat:addMessage', recruiterSource, {args = {'INFO', firstname .. ' ' .. lastname .. ' a refusé le contrat'}})
end)

-- ===============================
-- SYSTÈME DE PAIEMENT
-- ===============================

local function PayEmployees()
    for company, companyData in pairs(CompanyDatabase) do
        for citizenId, employee in pairs(companyData.employees) do
            local player = QBCore.Functions.GetPlayerByCitizenId(citizenId)
            if player then
                local salary = employee.salary
                if companyData.balance >= salary then
                    companyData.balance = companyData.balance - salary
                    companyData.statistics.total_expenses = companyData.statistics.total_expenses + salary
                    employee.total_earned = employee.total_earned + salary
                    
                    -- Ajouter l'argent au joueur
                    player.Functions.AddMoney('bank', salary, 'Company Salary')
                    TriggerClientEvent('chat:addMessage', player.PlayerData.source, {args = {'SALAIRE', 'Vous avez reçu $' .. salary .. ' de ' .. GetCompanyLabel(company)}})
                else
                    TriggerClientEvent('chat:addMessage', player.PlayerData.source, {args = {'ERREUR', 'L\'entreprise n\'a pas assez de fonds'}})
                end
            end
        end
    end
end

TriggerEvent('company:startPayroll')

AddEventHandler('company:startPayroll', function()
    SetInterval(Config.PayInterval, function()
        PayEmployees()
    end)
end)