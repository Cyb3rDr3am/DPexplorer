<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
	<h1>${message}</h1>
    <table>
        <thead>
            <tr>
                <th>identifiant</th>
                <th>classe</th>
            </tr>
        </thead>
        <tbody>
        <s:iterator value="batiments" var="batiment">
        	<tr>
    			<td><s:property value="#batiment.id"/></td>
    			<td><s:property value="#batiment.diagnostic.cEnergetique"/></td>
    			<td><s:property value="#batiment"/></td>
    			<td><a href = "
    			<s:url value='submitDPE'>
    				<s:param name='id' value='#batiment.id' />
				</s:url>">modifier</a></td>
				<td><a href = "
    			<s:url value='deleteDPE'>
    				<s:param name='id' value='#batiment.id' />
				</s:url>">supprimer</a></td>
    		</tr>
    	</s:iterator>
        </tbody>
    </table>
</body>
</html>
