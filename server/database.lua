-- Base de données des entreprises (à remplacer par une vraie DB)
CompanyDatabase = {}

-- Initialiser les entreprises
function InitializeCompanies()
    for companyName, companyData in pairs(Config.Companies) do
        CompanyDatabase[companyName] = {
            name = companyName,
            label = companyData.label,
            owner = nil,
            boss = {},
            employees = {},
            balance = 50000,
            income = 0,
            statistics = {
                total_revenue = 0,
                total_expenses = 0,
                employees_hired = 0,
                employees_fired = 0,
            }
        }
    end
    print("Companies initialized")
end

-- Obtenir les données d'une entreprise
function GetCompanyData(company)
    return CompanyDatabase[company]
end

-- Sauvegarder une entreprise
function SaveCompanyData(company, data)
    CompanyDatabase[company] = data
end

-- Ajouter un employé
function AddEmployee(company, citizenId, name, role)
    if not CompanyDatabase[company] then return false end
    
    CompanyDatabase[company].employees[citizenId] = {
        name = name,
        role = role,
        salary = CalculateSalary(company, role),
        hired_date = os.time(),
        total_earned = 0,
    }
    return true
end

-- Retirer un employé
function RemoveEmployee(company, citizenId)
    if not CompanyDatabase[company] then return false end
    CompanyDatabase[company].employees[citizenId] = nil
    CompanyDatabase[company].statistics.employees_fired = CompanyDatabase[company].statistics.employees_fired + 1
    return true
end

-- Ajouter des revenus
function AddCompanyIncome(company, amount)
    if not CompanyDatabase[company] then return false end
    CompanyDatabase[company].balance = CompanyDatabase[company].balance + amount
    CompanyDatabase[company].income = CompanyDatabase[company].income + amount
    CompanyDatabase[company].statistics.total_revenue = CompanyDatabase[company].statistics.total_revenue + amount
    return true
end

-- Retirer des revenus
function RemoveCompanyIncome(company, amount)
    if not CompanyDatabase[company] then return false end
    if CompanyDatabase[company].balance < amount then return false end
    CompanyDatabase[company].balance = CompanyDatabase[company].balance - amount
    CompanyDatabase[company].statistics.total_expenses = CompanyDatabase[company].statistics.total_expenses + amount
    return true
end

-- Définir le propriétaire
function SetCompanyOwner(company, citizenId, name)
    if not CompanyDatabase[company] then return false end
    CompanyDatabase[company].owner = {
        id = citizenId,
        name = name,
        appointed_date = os.time(),
    }
    AddEmployee(company, citizenId, name, 'owner')
    return true
end

-- Définir un boss
function AddCompanyBoss(company, citizenId, name)
    if not CompanyDatabase[company] then return false end
    if not CompanyDatabase[company].boss then
        CompanyDatabase[company].boss = {}
    end
    CompanyDatabase[company].boss[citizenId] = {
        name = name,
        appointed_date = os.time(),
    }
    AddEmployee(company, citizenId, name, 'boss')
    return true
end

-- Retirer un boss
function RemoveCompanyBoss(company, citizenId)
    if not CompanyDatabase[company] then return false end
    CompanyDatabase[company].boss[citizenId] = nil
    RemoveEmployee(company, citizenId)
    return true
end

-- Vérifier si un joueur est boss
function IsPlayerBoss(company, citizenId)
    if not CompanyDatabase[company] then return false end
    return CompanyDatabase[company].boss[citizenId] ~= nil
end

-- Vérifier si un joueur est propriétaire
function IsPlayerOwner(company, citizenId)
    if not CompanyDatabase[company] then return false end
    return CompanyDatabase[company].owner and CompanyDatabase[company].owner.id == citizenId
end

-- Vérifier si un joueur est employé
function IsPlayerEmployee(company, citizenId)
    if not CompanyDatabase[company] then return false end
    return CompanyDatabase[company].employees[citizenId] ~= nil
end