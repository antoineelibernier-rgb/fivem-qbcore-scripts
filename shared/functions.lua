function GetCompanyLabel(company)
    if Config.Companies[company] then
        return Config.Companies[company].label
    end
    return 'Inconnue'
end

function HasPermission(job, role, permission)
    if Config.Permissions[role] then
        return Config.Permissions[role][permission] or false
    end
    return false
end

function GetSalaryMultiplier(role)
    if Config.JobRoles[role] then
        return Config.JobRoles[role].salary_multiplier
    end
    return 1.0
end

function CalculateSalary(company, role)
    local baseCompanySalary = Config.Companies[company] and Config.Companies[company].salary or Config.BaseSalary
    local multiplier = GetSalaryMultiplier(role)
    return math.floor(baseCompanySalary * multiplier)
end