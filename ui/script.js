// Variables globales
let currentCompanyData = null;

// Initialisation
document.addEventListener('DOMContentLoaded', function() {
    setupEventListeners();
    setupTabNavigation();
});

// Configuration des écouteurs d'événements
function setupEventListeners() {
    // Bouton de fermeture
    document.getElementById('closeBtn').addEventListener('click', closeTablet);
    
    // Boutons de finances
    document.getElementById('withdrawBtn').addEventListener('click', withdrawMoney);
    document.getElementById('depositBtn').addEventListener('click', depositMoney);
}

// Configuration de la navigation par onglets
function setupTabNavigation() {
    const navButtons = document.querySelectorAll('.nav-btn');
    const tabContents = document.querySelectorAll('.tab-content');
    
    navButtons.forEach(button => {
        button.addEventListener('click', function() {
            const tabName = this.getAttribute('data-tab');
            
            // Retirer la classe active de tous les boutons et contenus
            navButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Ajouter la classe active au bouton et contenu sélectionnés
            this.classList.add('active');
            document.getElementById(tabName).classList.add('active');
        });
    });
}

// Réception des données NUI
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'showTablet') {
        currentCompanyData = data.data;
        displayTablet(data.data);
    }
});

// Afficher la tablette et mettre à jour les données
function displayTablet(companyData) {
    const tablet = document.getElementById('tablet');
    
    // Mettre à jour le titre
    document.getElementById('companyName').textContent = companyData.label || 'Tablette de Gestion';
    
    // Mettre à jour vue d'ensemble
    document.getElementById('balance').textContent = '$' + formatNumber(companyData.balance);
    document.getElementById('income').textContent = '$' + formatNumber(companyData.income);
    document.getElementById('employeeCount').textContent = Object.keys(companyData.employees).length;
    document.getElementById('expenses').textContent = '$' + formatNumber(companyData.statistics.total_expenses);
    
    // Mettre à jour statistiques
    document.getElementById('totalRevenue').textContent = '$' + formatNumber(companyData.statistics.total_revenue);
    document.getElementById('totalExpenses').textContent = '$' + formatNumber(companyData.statistics.total_expenses);
    document.getElementById('totalHired').textContent = companyData.statistics.employees_hired;
    document.getElementById('totalFired').textContent = companyData.statistics.employees_fired;
    
    // Mettre à jour liste des employés
    updateEmployeesList(companyData.employees);
    
    // Afficher la tablette
    tablet.classList.remove('hidden');
}

// Mettre à jour la liste des employés
function updateEmployeesList(employees) {
    const employeesList = document.getElementById('employeesList');
    employeesList.innerHTML = '';
    
    for (const [citizenId, employee] of Object.entries(employees)) {
        const row = document.createElement('tr');
        const hiredDate = new Date(employee.hired_date * 1000).toLocaleDateString('fr-FR');
        
        row.innerHTML = `
            <td>${employee.name}</td>
            <td>${getRoleLabel(employee.role)}</td>
            <td>$${formatNumber(employee.salary)}</td>
            <td>${hiredDate}</td>
            <td>
                <button class="action-btn" onclick="fireEmployee('${citizenId}')">Licencier</button>
            </td>
        `;
        
        employeesList.appendChild(row);
    }
}

// Fermer la tablette
function closeTablet() {
    const tablet = document.getElementById('tablet');
    tablet.classList.add('hidden');
    
    // Envoyer l'événement au serveur
    fetch(`https://${GetParentResourceName()}/closeTablet`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

// Retirer de l'argent
function withdrawMoney() {
    const amount = parseInt(document.getElementById('withdrawAmount').value);
    
    if (isNaN(amount) || amount <= 0) {
        alert('Montant invalide');
        return;
    }
    
    if (amount > currentCompanyData.balance) {
        alert('Fonds insuffisants');
        return;
    }
    
    // Envoyer à la NUI et au serveur
    fetch(`https://${GetParentResourceName()}/withdrawMoney`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            amount: amount
        })
    });
    
    document.getElementById('withdrawAmount').value = '';
}

// Ajouter de l'argent
function depositMoney() {
    const amount = parseInt(document.getElementById('depositAmount').value);
    
    if (isNaN(amount) || amount <= 0) {
        alert('Montant invalide');
        return;
    }
    
    fetch(`https://${GetParentResourceName()}/depositMoney`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            amount: amount
        })
    });
    
    document.getElementById('depositAmount').value = '';
}

// Licencier un employé
function fireEmployee(citizenId) {
    if (confirm('Êtes-vous sûr de vouloir licencier cet employé ?')) {
        fetch(`https://${GetParentResourceName()}/fireEmployee`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                citizenId: citizenId
            })
        });
    }
}

// Utilitaires
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
}

function getRoleLabel(role) {
    const roleLabels = {
        'owner': 'Propriétaire',
        'boss': 'Boss',
        'employee': 'Employé'
    };
    return roleLabels[role] || role;
}

function GetParentResourceName() {
    return 'fivem-qbcore-scripts';
}