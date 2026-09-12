Config = {}

-- Entreprises disponibles
Config.Companies = {
    ['pizza'] = {
        name = 'Pizzeria',
        label = 'Pizzeria Italia',
        icon = 'pizza-slice',
        location = vector3(295.42, -349.54, 45.1),
        boss_location = vector3(295.42, -349.54, 45.1),
        recruiter_offset = 2.0,
        salary = 500,
        maxEmployees = 15,
    },
    ['mechanic'] = {
        name = 'Mechanic',
        label = 'Bennys Original Motor Works',
        icon = 'wrench',
        location = vector3(-370.35, -134.26, 39.02),
        boss_location = vector3(-370.35, -134.26, 39.02),
        recruiter_offset = 2.0,
        salary = 600,
        maxEmployees = 20,
    },
    ['police'] = {
        name = 'Police',
        label = 'Police Department',
        icon = 'badge',
        location = vector3(425.15, -982.56, 29.44),
        boss_location = vector3(425.15, -982.56, 29.44),
        recruiter_offset = 2.0,
        salary = 700,
        maxEmployees = 50,
    },
    ['ambulance'] = {
        name = 'Ambulance',
        label = 'EMS - Ambulance',
        icon = 'heart',
        location = vector3(296.15, -584.23, 43.26),
        boss_location = vector3(296.15, -584.23, 43.26),
        recruiter_offset = 2.0,
        salary = 650,
        maxEmployees = 25,
    },
}

-- Rôles disponibles
Config.JobRoles = {
    owner = { label = 'Propriétaire', salary_multiplier = 1.5 },
    boss = { label = 'Boss', salary_multiplier = 1.2 },
    employee = { label = 'Employé', salary_multiplier = 1.0 },
}

-- Permissions par rôle
Config.Permissions = {
    owner = {
        manage_company = true,
        hire_fire = true,
        view_statistics = true,
        manage_salary = true,
        create_jobs = true,
        tablet_access = true,
    },
    boss = {
        manage_company = true,
        hire_fire = true,
        view_statistics = true,
        manage_salary = false,
        create_jobs = false,
        tablet_access = true,
    },
    employee = {
        manage_company = false,
        hire_fire = false,
        view_statistics = false,
        manage_salary = false,
        create_jobs = false,
        tablet_access = false,
    },
}

-- Salaire de base
Config.BaseSalary = 500

-- Intervalle de paiement (en millisecondes)
Config.PayInterval = 5 * 60 * 1000 -- 5 minutes pour les tests

-- Debug
Config.Debug = true