<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ville formulaire</title>
</head>
<body>
		<div class="container">
		<div class="left-part-container box">
			<img src="./images/logo1.png" id="logo-bar" alt="logo-dpexplorer"
				style="width: 150px; height: 150px" />
			<form action="SearchForm" method="post">
				<s:submit class="button-left-bar" value="Formulaire de recherche"
					name="actionName" cssStyle="border-top: 2px solid black" />
			</form>
			<form action="submitDPE" method="post">
				<s:submit class="button-left-bar" value="Ajout de données"
					name="actionName" />
			</form>
			<form action="Map" method="post">
				<s:submit class="button-left-bar" value="Carte" name="actionName" />
			</form>
		</div>
		<div class="right-part-container">
			<div class="form-menu-div">
				<form action="rue" method="post">
					<s:submit class="form-menu-container" value="Rue"
						name="actionName" cssStyle="border-top: 2px solid black" />
				</form>
				<form action="ville" method="post">
					<s:submit class="form-menu-container" value="Ville"
						name="actionName" />
				</form>
				<form action="submitDPE" method="post">
					<s:submit class="form-menu-container" value="DPE" name="actionName" />
				</form>
			</div>
			<div class="bottom-container">
				<s:form action="villeForm">
					<s:if test="%{villeForm.id != null}">
						<h1>Modifier une ville </h1>
					</s:if>
					<s:else>
						<h1>Insérer une ville</h1>
					</s:else>
					<s:hidden name="villeForm.id"/>
					<s:fielderror fieldName="villeForm.cPostal" />
					<s:textfield name="villeForm.cPostal" label="Code Postal" />
					<s:fielderror fieldName="villeForm.nom" />
					<s:textfield name="villeForm.nom" label="nom" />
					<s:fielderror fieldName="villeForm.idRues" />
					<s:select label="Rue"
          			name="villeForm.idRues"
          			multiple="true"
          			id="idRues"
          			list="rues"
          			listKey="id"
          			listValue="nom"
          			hidden="true"/>
          			<s:select
          				id="idRue"
          				list="rues"
          				listKey="id"
          				listValue="nom"
          				headerKey="-1"
          				headerValue="--Select--"
          				onChange="addRue()"
          				cssClass="custom-select"/>
          			<div class="submit-container">
						<s:submit value="💾 Enregistrer" cssClass="blue-submit-button" />
					</div>
				</s:form>
			</div>
		</div>
	</div>
</body>
<script>
	function addRue() {
		var select = document.getElementById("idRue");
		var multiselect = document.getElementById("idRues");
		for (var i = 0; i < multiselect.options.length; i++) {
			  var option = multiselect.options[i];
			  if (option.value === select.value) {
				  addRueListe(option);
				  break;
			  }
		}
	}
	function addRueListe(option) {
		var select = document.getElementById("idRue");
		var multiselect = document.getElementById("idRues");
		var listRue = document.getElementById("listRue");
	    option.selected = true;
	    select.remove(select.selectedIndex);
	    select.options[0].selected = true;
	    var li = document.createElement("li");
	    var deleteButton = document.createElement("button");
	    deleteButton.textContent = "Supprimer";
	    deleteButton.addEventListener("click", function () {
	      option.selected = false;
		  var newOption = document.createElement("option");
		  newOption.value = option.value;
		  newOption.textContent = option.textContent;
		  select.appendChild(newOption);
	      li.parentNode.removeChild(li);
	    });
	    li.textContent = option.textContent;
	    li.appendChild(deleteButton);
	    listRue.appendChild(li);
	}
	window.onload = function() {
		document.querySelectorAll('ul.errorMessage').forEach(el => el.remove());
		var ulElement = document.createElement("ul");
		ulElement.id = "listRue";
		var idRueElement = document.getElementById("idRue");
		idRueElement.parentNode.insertBefore(ulElement, idRueElement.nextSibling);
		var select = document.getElementById("idRue");
		var multiselect = document.getElementById("idRues");
		for (var i = 0; i < multiselect.options.length; i++) {
			  var option = multiselect.options[i];
				if (option.selected) {
					select.value = option.value;
					addRueListe(option);
				}
		}

	}
</script>

<style>
	.form-menu-div {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            height: 5vh;
            padding-top: 50px;
            margin-bottom: 50px;
        }

        .form-menu-div > form {
        }
        .form-menu-div input {
        	padding: 15px 32px;
  			text-align: center;
  			text-decoration: none;
  			font-size: 16px;
  			width: 500px;
  			height: 100%;
  			display: inline-block;
  			border: 2px solid black;
  			
  		}
h1 {
	text-align: center;
	color: red;
}

.custom-select {
	width: 450px;
	height: 40px;
	font-size: 16px;
	padding: 5px;
}

#villeForm {
	width: 100%;
	max-width: 600px; margin : auto;
	padding: 20px;
	border: 1px solid #ddd;
	border-radius: 10px;
	background-color: #f9f9f9;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	margin: auto;
	margin-top: 50px;
}

.blue-submit-button {
	float: right;
	background-color: #007BFF;
	color: white;
	border: none;
	padding: 10px 15px;
	border-radius: 20px;
	cursor: pointer;
	font-size: 16px;
}

.blue-submit-button:hover {
	background-color: #0056b3;
}

.submit-container {
	text-align: right;
	overflow: auto;
}

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
	left: 0px;
}

div.right-part-container {
	margin-left: 160px;
	margin-right: auto;
	width: calc(100% - 160px);
	align-items: center;
}
div.bottom-container {
	display: flex;
	justify-content: center;
	min-height: 50vh;
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
</style>
</html>