<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<title>Rues</title>
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
			<div class="error-message">
				<s:property value="error" escapeHtml="false" />
			</div>
			<s:form action="insertRue">
				<s:textfield name="nom" label="Nom de la rue" required="required" />
				<s:submit value="Inserer" />
			</s:form>
			<table>
				<thead>
					<tr>
						<th>identifiant</th>
						<th>nom</th>
						<td></td>
					</tr>
				</thead>
				<tbody>
					<s:iterator value="rues" var="rue">
						<tr>
							<td><s:property value="#rue.id" /></td>
							<td><s:property value="#rue.nom" /></td>
							<td><s:form action="deleteRue">
									<s:hidden name="id" value="%{#rue.id}" />
									<s:submit value="❌" cssClass="delete-button" />
								</s:form></td>
						</tr>
					</s:iterator>
				</tbody>
			</table>
		</div>
	</div>
</body>
<style>
	.form-menu-div {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            padding-top: 50px;
            margin-bottom: 10px;
        }

        .form-menu-div > form {
        	margin:0
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
/////////////////////////////////////////////////////////////////////
th {
	padding-top: 12px;
	padding-bottom: 12px;
	text-align: left;
	background-color: grey;
	color: white;
}

td, th {
	border: 1px solid #ddd;
	padding: 8px;
}

tr:nth-child(even) {
	background-color: #f2f2f2;
}

table {
	font-family: Arial, Helvetica, sans-serif;
	border-collapse: collapse;
	width: 100%;
}

.delete-button {
	font-size: 20px;
	border: none;
	cursor: pointer;
	padding: 5px 10px;
	border-radius: 10%;
}

////////////////////////////////////////////////////////////////
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
