local QBCore = exports['qb-core']:GetCoreObject()
local playerJob = nil
local inRecruiterZone = false
local currentCompany = nil

-- Récupérer le job du joueur
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    playerJob = JobInfo
end)

-- ===============================
-- ZONES DE RECRUITEMENT
-- ===============================

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for company, data in pairs(Config.Companies) do
            CreateRecruiterZone(company, data)
        end
    end
end)

function CreateRecruiterZone(company, data)
    -- Zone de recruitement
    exports['qb-target']:AddBoxZone('recruiter_' .. company, data.location, 2.0, 2.0, {
        name = 'recruiter_' .. company,
        heading = 0,
        debugPoly = false,
        minZ = data.location.z - 1,
        maxZ = data.location.z + 1,
    }, {
        options = {
            {
                type = 'client',
                event = 'company:startRecruitement',
                icon = 'fas fa-handshake',
                label = 'Proposer un emploi',
                args = {company}
            }
        },
        distance = 2.5
    })
end

-- Proposer un emploi
RegisterNetEvent('company:startRecruitement')
AddEventHandler('company:startRecruitement', function(company)
    local playersNearby = GetPlayersNearby(2.0)
    
    if #playersNearby == 0 then
        QBCore.Functions.Notify('Aucun joueur à proximité', 'error')
        return
    end
    
    local options = {}
    for _, playerId in ipairs(playersNearby) do
        if playerId ~= PlayerPedId() then
            local targetPlayer = GetPlayerName(playerId)
            table.insert(options, {
                header = targetPlayer,
                txt = 'Proposer un emploi',
                params = {
                    event = 'company:sendContractOffer',
                    args = {playerId, company}
                }
            })
        end
    end
    
    exports['qb-menu']:openMenu(options)
end)

-- Envoyer une offre de contrat
RegisterNetEvent('company:sendContractOffer')
AddEventHandler('company:sendContractOffer', function(targetId, company)
    local targetPlayer = GetPlayerFromServerId(targetId)
    if targetPlayer == 0 then
        QBCore.Functions.Notify('Joueur introuvable', 'error')
        return
    end
    
    TriggerServerEvent('company:proposeContract', targetId, company)
end)

-- Recevoir une offre de contrat
RegisterNetEvent('company:receiveContract')
AddEventHandler('company:receiveContract', function(contractData)
    local options = {
        {
            header = 'Offre d\'emploi',
            txt = contractData.from .. ' vous propose un emploi chez ' .. contractData.companylabel,
            params = {
                event = 'company:acceptContractClient',
                args = {contractData.company, contractData.source}
            }
        },
        {
            header = 'Refuser',
            txt = 'Décliner l\'offre',
            params = {
                event = 'company:rejectContractClient',
                args = {contractData.source, contractData.from}
            }
        }
    }
    exports['qb-menu']:openMenu(options)
end)

-- Accepter un contrat
RegisterNetEvent('company:acceptContractClient')
AddEventHandler('company:acceptContractClient', function(company, recruiterSource)
    TriggerServerEvent('company:acceptContract', company, recruiterSource)
    QBCore.Functions.Notify('Contrat accepté!', 'success')
end)

-- Refuser un contrat
RegisterNetEvent('company:rejectContractClient')
AddEventHandler('company:rejectContractClient', function(recruiterSource, recruiterName)
    TriggerServerEvent('company:rejectContract', recruiterSource)
    QBCore.Functions.Notify('Contrat refusé', 'inform')
end)

-- ===============================
-- TABLETTE DE GESTION
-- ===============================

-- Commande pour ouvrir la tablette
RegisterCommand('tablet', function()
    if playerJob and playerJob.name then
        TriggerServerEvent('company:openTablet', playerJob.name)
    else
        QBCore.Functions.Notify('Vous n\'avez pas de job', 'error')
    end
end)

-- Recevoir et afficher les données d'entreprise
RegisterNetEvent('company:showTablet')
AddEventHandler('company:showTablet', function(companyData)
    TriggerEvent('company:openTabletUI', companyData)
end)

-- Ouvrir l'interface de la tablette
RegisterNetEvent('company:openTabletUI')
AddEventHandler('company:openTabletUI', function(companyData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showTablet',
        data = companyData
    })
end)

-- Fermer la tablette
RegisterNUICallback('closeTablet', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- ===============================
-- FONCTIONS UTILITAIRES
-- ===============================

function GetPlayersNearby(distance)
    local players = {}
    for _, playerId in ipairs(GetActivePlayers()) do
        local playerPed = GetPlayerPed(playerId)
        local playerCoords = GetEntityCoords(playerPed)
        local playerDistance = #(playerCoords - GetEntityCoords(PlayerPedId()))
        if playerDistance <= distance and playerId ~= PlayerId() then
            table.insert(players, GetPlayerServerId(playerId))
        end
    end
    return players
end