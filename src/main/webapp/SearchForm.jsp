<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Formulaire de recherche</title>
</head>
<body >
	
	<div class="container">
		<div class="left-part-container box">
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
		
		<div class="right-part-container box">
		
			<h1 style="text-align:center"><b><u>Formulaire de recherche</u></b></h1>
			<div style="position: absolute; right: 0; top: 0; z-index: -1; margin-top: 10px; margin-right: 10px;">
				<img src="./images/house-energies.jpeg" alt="house-energies" style="width: 150px; height: 150px" />
			</div>
			
			<form action="SearchForm" method="post">
			
					<div class="filter-form">
						<div class="part-filter-form">
							<s:textfield label="Recherche par mot " type="text" name="searchInput" class="input-filter" 
								placeholder="Nom de rue et ville"  />
						</div>
						<div class="part-filter-form" style="margin-left:25px">
							<s:select list="{'Tous','A','B','C','D','E','F'}"  name="classEnergySelect" cssStyle="height: 31px; padding-left: 20px;"
								class="input-filter" label="Classe(s) énergétique(s) " />
						</div>
						<div class="part-filter-form" style="margin-left:50px">
							<s:submit name="actionName" value="Rechercher" style="height: 30px;" />
						</div>
					</div>
			
				    <table class="form-table">
				        <thead>
				            <tr>
					            <s:iterator value="columnNames" var="colName">
				                	<th>
				                		<s:if test="#colName != 'Actions'">
						                	<s:url var="actionSortingURL">
							                	<s:param name="search"><s:property value="searchInput" /></s:param>
							    				<s:param name="class"><s:property value="classEnergySelect" /></s:param>
								    			<s:param name="sortBy"><s:property value="#colName" /></s:param>
								    			<s:param name="page"><s:property value="currentPage" /></s:param>
								    			<s:param name="isAscending">
											        <s:if test="#colName == columnSorted">
											            <s:if test="isAscending">false</s:if>
											            <s:else>true</s:else>
											        </s:if>
											        <s:else>true</s:else>
											    </s:param>
								    			<s:param name="searchInput"><s:property value="searchInput" /></s:param>
								    		</s:url>
											<a href="${actionSortingURL}">
									            <button class="button-table" type="button" name="actionName" value="columnSorted">
									                <s:property value="#colName"/>
						                			<s:if test='#colName == columnSorted'>
							                			<s:if test='isAscending'>
								    						<span style="font-size: 20px; font-weight: bold">↓</span>
							    						</s:if>
							    						<s:else>
							    							<span style="font-size: 20px; font-weight: bold">↑</span>
							    						</s:else>
							    					</s:if>
									            </button>
									        </a>
								       </s:if>
			                		</th>
				                </s:iterator>
				            </tr>
				        </thead>
				        <tbody>
				        <s:iterator value="batimentsResp" var="batiment">
				        	<tr>
				    			<td><s:property value="#batiment.id"/></td>
				    			<td><s:property value="#batiment.numero"/></td>
				    			<td><s:property value="#batiment.nomRue"/></td>
				    			<td><s:property value="#batiment.nomVille"/></td>
				    			<td><s:property value="#batiment.codePostal"/></td>
				    			<td><s:property value="#batiment.anneeConstruction"/></td>
				    			<td><s:property value="#batiment.consommation"/></td>
				    			
				    			<td class="bgColor<s:property value='#batiment.classeEnergetique.toString()'/>">
				    				<s:property value='#batiment.classeEnergetique.toString()'/>
				    			</td>
				    			<td>
				    				<button class="actions-button" name="actionName" value="Modifier" title="Modifier">✏️</button>
				    				<button class="actions-button" type="submit" name="actionName"  value="Supprimer<s:property value='#batiment.id'/>" 
				    					title="Supprimer">❌</button>
				    			</td>
				    		</tr>
				    	</s:iterator>
				        </tbody>
				    </table>
			    
				    <div class="filter-form">
				    	<s:iterator value="numPageDisplayed" var="numPage">
					    	<s:if test='#numPage == currentPage'>
						    	<s:submit disabled="true" class="page-input" value="%{numPage}" name="actionName" />
					    	</s:if>
					    	<s:elseif test='#numPage == "..."'>
						    	<span class="page-input"><s:property value="#numPage"/></span>
					    	</s:elseif>
					    	<s:else>		
								<s:url var="actionPageURL">
					    			<s:param name="search"><s:property value="searchInput" /></s:param>
					    			<s:param name="class"><s:property value="classEnergySelect" /></s:param>
									<s:param name="sortBy"><s:property value="columnSorted" /></s:param>
					    			<s:param name="page"><s:property value="#numPage" /></s:param>
					    			<s:param name="isAscending"><s:property value="isAscending" /></s:param>
					    		</s:url>
								<a href="${actionPageURL}">
						            <button class="page-input" type="button" name="actionName" value="page">
						                <s:property value="numPage" />
						            </button>
						        </a>
					    	</s:else>
				    	</s:iterator>
				    </div>
		    </form>
	    </div>
    </div>

</body>
<script>
document.addEventListener("DOMContentLoaded", function() {
    var buttons = document.querySelectorAll(".actions-button");

    buttons.forEach(function(button) {
        if (button.getAttribute("title") === "Modifier") {
            button.addEventListener("click", async function() { 
            	event.preventDefault();
                const batimentId = this.closest("tr").querySelector("td:nth-child(1)").textContent;
                window.location.href = "${path}/submitDPE?id=" + batimentId;
            });
        }
    });
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

/////////////////////////////////////
/////////////////////////////////////

div.part-filter-form {
	display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-left: 15px;
    margin-right: 15px;
    margin-bottom: 30px;
}

div.filter-form {
    display: flex; 
    justify-content: center;
    align-items: center; 
    margin-top: 30px;
    margin-bottom: 50px;
}
.input-filter {
	width: 200px; 
	height: 25px;
	font-size: medium;
}

table.form-table {
	width: 90%; 
    margin-left: auto; 
    margin-right: auto; 
    border-collapse: separate;
    border: 3px solid #000;
    border-radius: 5px;
    border-spacing: 0;
}
table.form-table th {
	width: 12.5%;
	background-color: #ddd;
}
table.form-table td {
	padding: 8px;
	font-size: 15px;
}
table.form-table td, table.form-table th {
    border: 1px solid #aaa;
    text-align: center;
}

.input-filter option[value="Tous"] { background: #ddd }
.bgColorA, .input-filter option[value="A"] { background-color: #15821F }
.bgColorB, .input-filter option[value="B"] { background-color: #5DBA51 }
.bgColorC, .input-filter option[value="C"] { background-color: #ACDE48 }
.bgColorD, .input-filter option[value="D"] { background-color: #FBDC31 }
.bgColorE, .input-filter option[value="E"] { background-color: #FDAE25 }
.bgColorF, .input-filter option[value="F"] { background-color: #D75F15 }
.bgColorG, .input-filter option[value="G"] { background-color: #FF0036 }

.page-input {
	border-radius: 15px;
	margin-left: 5px;
	margin-right: 5px;
}

.button-table {
	width: 100%;
	heigth: 100%;
	padding: 8px;
	background-color: #ddd;
    transition: background-color 0.15s;
    border: none;
    outline: none; 
    cursor: pointer;
    font-size: 15px;
    font-weight: bold;
    min-height: 70px; 	
}
.button-table:hover, .button-left-bar:hover {
    background-color: #ccc; 
}
.button-table:active, .button-left-bar:active {
    background-color: #bbb; 
}
.actions-button {
	background-color: #fff;
	border: none;
    outline: none; 
    cursor: pointer;
}
</style>
</html>