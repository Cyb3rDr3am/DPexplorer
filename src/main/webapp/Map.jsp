<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Carte des bâtiments</title>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
</head>
<body>
	<div class="container">
		<div class="left-part-container">
			<img src="./images/logo1.png" id="logo-bar" alt="logo-dpexplorer" style="width: 150px; height: 150px" />
			<form action="SearchForm" method="post">
				<s:submit class="button-left-bar" value="Formulaire de recherche" name="actionName" cssStyle="border-top: 2px solid black" />
			</form>
			<form action="submitDPE" method="post">
				<s:submit class="button-left-bar" value="Ajout de données" name="actionName" />
			</form>
			<form action="Map" method="post">
				<s:submit class="button-left-bar" value="Carte" name="actionName" />
			</form>
		</div>

		<div class="right-part-container">
			<h1 style="text-align:center"><b><u>Carte des bâtiments</u></b></h1>
			<div class="map-form">
				<form action="Map" method="post">
					<div class="part-map-form" style="height: 100%;">
						<div style="padding: 3px">
							<label for="villeSelected">Ville :</label>
							<s:select
							  cssStyle="margin-bottom: 10px;" 
							  id="villeSelected"
					          name="villeSelected"
					          list="listVilles"
					          listKey="id"
					          listValue="cPostal.code + ' ' + nom"
					          cssClass="input-filter"
					          headerKey="-1"
					          headerValue="--Select--"
				          	/>
				          	<br/>
				          	<label for="rueSelected">Rue :</label>
				          	<s:select
					          cssStyle="margin-top: 10px; margin-bottom: 10px;" 
					          id="rueSelected"
					          name="rueSelected"
					          list="{}"
					          listKey="id"
					          listValue="nom"
					          cssClass="input-filter"
					          headerKey="-1"
					          headerValue="--Select--"
					          disabled="true"
				          	/>
				          	<br/>
				          	<label for="numeroSelected">Numéro :</label>
				          	<s:select
					          cssStyle="margin-top: 10px; margin-bottom: 10px; width: 50%;" 
					          name="numeroSelected"
					          list="{}"
					          listKey="numero"
					          listValue="numero"
					          cssClass="input-filter"
					          headerKey="-1"
					          headerValue="--Select--"
					          disabled="true"
				          	/>
				          	<br/>
							<button name="actionName" id="rechercher-adresse" value="Rechercher par adresse" style="height: 30px; margin-top: 10px">
								Rechercher par adresse
							</button>
						</div> 
						
					</div>
<%-- 					<div class="part-map-form" style="border-top: 2px solid #aaa; height: 35%;">
						<div>
							<label for="classEnergySelect">Classe(s) énergétique(s) :</label>
							<s:select list="{'Tous','A','B','C','D','E','F'}"  name="classEnergySelect" cssStyle="height: 31px;"
								class="input-filter" id="classEnergySelect" />
							<s:submit name="actionName" value="Rechercher par classe" id="rechercher-classe" style="height: 30px; margin-top: 10px" />
						</div>
					</div> --%>
				</form>
				
				<div id="map" style="height: 500px; width: 75%;"></div>
			</div>
		</div>
	</div>
</body>

<script>

// Vérifier si l'utilisateur a internet
fetch('https://www.google.com', { mode: 'no-cors' })
	.catch(error => {
		document.getElementById("villeSelected").disabled = true;
		document.getElementById("classEnergySelect").disabled = true;
		document.getElementById("rechercher-classe").disabled = true;
	})

var defaultLatitude = 50.7;
var defaultLongitude = 2.23;

async function assignDefaultCoordinates() {
	try {
		resp = await getCoordinates("Pas-de-Calais, France");
		defaultLatitude = resp.lat;
		defaultLongitude = resp.lon;
	} catch {}
}
assignDefaultCoordinates();

var map = L.map('map');

if ("geolocation" in navigator) {
    navigator.geolocation.getCurrentPosition(function(position) {
        latitude = position.coords.latitude;
        longitude = position.coords.longitude;
        map.setView([latitude, longitude], 13);
    }, function(error) {
    	map.setView([defaultLatitude, defaultLongitude], 13);
    });
} else {
    console.error("Geolocation is not supported by this browser.");
    map.setView([defaultLatitude, defaultLongitude], 13);
}

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

async function getCoordinates(adresse) {
    try {
        const response = await fetch('${path}//coordinatesMap.action?adresse=' + adresse);
        const data = await response.json();
        return data;
    } catch (error) {
        throw error;
    }
}

//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
    
async function loadDataRues(idVille, select) {
    return new Promise((resolve, reject) => {
        fetch('${path}//listRue.action?idVille=' + idVille)
        .then(response => response.json())
        .then(data => {
            for (var i = select.options.length - 1; i > 0; i--) {
            	select.remove(i);
        	}
            for (k in data) {
                let nouvelleOption = document.createElement("option");
                nouvelleOption.text = data[k]["nom"];
                nouvelleOption.value = data[k]["id"];
                select.appendChild(nouvelleOption);
            }
            resolve();
        })
        .catch(error => {
            reject(error); 
        });
    });
}
    
async function loadDataNumeros(idVille, idRue, select) {
    return new Promise((resolve, reject) => {
        fetch('${path}//listDPE.action?idVille=' + idVille + '&idRue=' + idRue)
        .then(response => response.json())
        .then(data => {
            for (var i = select.options.length - 1; i > 0; i--) {
            	select.remove(i);
        	}
            for (k in data) {
                let nouvelleOption = document.createElement("option");
                nouvelleOption.text = data[k]["numero"];
                nouvelleOption.value = data[k]["numero"];
                select.appendChild(nouvelleOption);
            }
            resolve();
        })
        .catch(error => {
            reject(error); 
        });
    });
}

async function getDataDPE(idVille, idRue, numero) {
	try {
        const response = await fetch('${path}//listDPE.action?' +
       		'idVille=' + (idVille ? + idVille : '-1') +
       		'&idRue=' + (idRue ? idRue : '-1') +
       		'&numero=' + (numero ?  + numero : '-1')
        );
        const data = await response.json();
        return data;
    } catch (error) {
        throw error;
    }
}
    
var idVilleSelected = -1;
var idRueSelected = -1;
var numeroSelected = -1;
document.getElementById("villeSelected").value = "-1";

// load rues
document.getElementById("villeSelected").addEventListener("change", async () => {
	idVilleSelected = document.getElementById("villeSelected").value;
	document.getElementById("rueSelected").disabled = idVilleSelected == -1;
	if (idVilleSelected != -1) {
		var selectRues = document.getElementById('rueSelected');
		await loadDataRues(idVilleSelected, selectRues);
		document.getElementById("rueSelected").disabled = false;
	} else {
		rueSelected = -1;
		document.getElementById("rueSelected").disabled = true;
		document.getElementById("rechercher-adresse").disabled = true;
	}
	document.getElementById("rueSelected").value = -1; 
	document.getElementById("numeroSelected").value = -1;
	numeroSelected = -1;
	document.getElementById("numeroSelected").disabled = true;
});

// load numeros
document.getElementById("rueSelected").addEventListener("change", async () => {
	idRueSelected = document.getElementById("rueSelected").value;
	if (idRueSelected != -1) {
		var selectNumero = document.getElementById('numeroSelected');
		await loadDataNumeros(idVilleSelected, idRueSelected, selectNumero);
		document.getElementById("numeroSelected").disabled = false;
	} else {
		document.getElementById("numeroSelected").disabled = true;
		numeroSelected = -1;
		document.getElementById("numeroSelected").value = -1; 
	}
});

document.getElementById("numeroSelected").addEventListener("change", () => {
	numeroSelected = document.getElementById("numeroSelected").value;
});


document.getElementById("rechercher-adresse").addEventListener("click", async (event) => {
	map.eachLayer(function(layer) {
	    if (layer instanceof L.Marker) {
	        map.removeLayer(layer);
	    }
	});
	event.preventDefault();
	const valueNumero = document.getElementById("numeroSelected").value;
	const valueRue = document.getElementById("rueSelected").options[document.getElementById("rueSelected").selectedIndex].innerText;
	const valueVille = document.getElementById("villeSelected").options[document.getElementById("villeSelected").selectedIndex].innerText;
	var adresse = "";
	if (idVilleSelected == -1) adresse = "Pas-de-Calais";
	else if (idVilleSelected != -1 && idRueSelected == -1) adresse = valueVille;
	// else if (idVilleSelected != -1 && idRueSelected != -1 && numeroSelected == -1) adresse = valueRue + ", " + valueVille;
	// else adresse = valueNumero + " " +valueRue + ", " + valueVille;
	else adresse = valueRue + ", " + valueVille; 
	// /!\ impossible d'avoir l'adresse précise avoir le numéro /!\
	const respCoord = await getCoordinates(adresse + ", France");
	if (respCoord.lat != -1 && respCoord.lon != -1) {
		map.setView([respCoord.lat, respCoord.lon], 13);
		const textPopup = "";
		var dictClass = { "A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F": 0, "G": 0 };
		const respBatiments = await getDataDPE(idVilleSelected, idRueSelected, valueNumero);
		respBatiments.forEach(batiment => dictClass[batiment.diagnostic.cEnergetique] += 1);
		var text = "";
		for (var classEnergy in dictClass) {
	        var value = dictClass[classEnergy];
	        text += "<span class=\"bgColor" + classEnergy + "\">" + classEnergy + "</span>: " +
	        		value + " logements<br/>";
		}
		L.marker([respCoord.lat, respCoord.lon]).addTo(map)
			.bindPopup(text); 
	}
});

</script>
<style>
body, html {
  margin: 0;
  padding: 0;
  font-family: sans-serif;
}
div.container {
  display: flex; 
  width: 100%;   
}

div.left-part-container {
	width: 150px;
	height: 100%;
	border-right: 3px solid black;
	background-color: #aaa;
	position: fixed;
}
div.right-part-container {
    margin-left: 160px;
    margin-right: auto;     
    width: calc(100% - 160px); 
}
.button-left-bar {
	width: 100%;
	height: 80px;
	padding: 8px;
	background-color: #eee;
    transition: background-color 0.15s;
    border: none;
    outline: none; 
    cursor: pointer;
    font-size: 15px;
    font-weight: bold;
    white-space: pre-line;
    border-bottom: 2px solid black;
}
.button-left-bar:hover {
    background-color: #ccc; 
}
.button-left-bar:active {
    background-color: #bbb; 
}

//////////////////////
//////////////////////
//////////////////////

div#map {
	height: 500px;
}

div.map-form {
	display: flex; 
	margin-top: 20px; 
	justify-content: center;
}
div.map-form form {
	width: 20%;
	border: 2px solid #000;
    border-radius: 5px;
    margin-right: 10px;
    text-align: center;
}
div.part-map-form {
    display: flex;
    align-items: center;
    justify-content: center;
}
.input-filter {
	width: 80%; 
	height: 25px;
	font-size: medium;
}
.input-filter option[value="Tous"] { background: #ddd }
.bgColorA, .input-filter option[value="A"] { background-color: #15821F }
.bgColorB, .input-filter option[value="B"] { background-color: #5DBA51 }
.bgColorC, .input-filter option[value="C"] { background-color: #ACDE48 }
.bgColorD, .input-filter option[value="D"] { background-color: #FBDC31 }
.bgColorE, .input-filter option[value="E"] { background-color: #FDAE25 }
.bgColorF, .input-filter option[value="F"] { background-color: #D75F15 }
.bgColorG, .input-filter option[value="G"] { background-color: #FF0036 }


</style>
</html>