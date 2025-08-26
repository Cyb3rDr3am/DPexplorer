package actions;

import com.opensymphony.xwork2.ActionSupport;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.struts2.ServletActionContext;
import ilidpe.persistence.*;
import ilidpe.persistence.formular.BatimentResponse;
import ilidpe.persistence.formular.PageBatimentRequest;
import ilidpe.persistence.formular.PageBatimentRequest.NomColonne;
import ilidpe.persistence.formular.PageBatimentResponse;


public class SearchFormAction extends ActionSupport  {
	private static final int MAX_ELEMENTS_PER_PAGE = 20;
	private static final int MAX_PAGES_DISPLAYED = 5;
	
	private BatimentTDG btdg;

	private final String[] columnNames = new String[]{ "Identifiant",
		"Numéro de rue", "Rue", "Ville", "Code postal", "Année de construction",
		"Consommation (kWh/m2 par an)",	"Classe énergétique"
	};
	private final Map<String, NomColonne> mapColumnNames = new HashMap<>() {{
		    put("Identifiant", NomColonne.IDENTIFIANT);
		    put("Numéro de rue", NomColonne.NUMERO);
		    put("Rue", NomColonne.RUE);
		    put("Ville", NomColonne.VILLE);
		    put("Code postal", NomColonne.CODE_POSTAL);
		    put("Année de construction", NomColonne.ANNEE_CONSTRUCTION);
		    put("Consommation (kWh/m2 par an)", NomColonne.CONSOMMATION);
		    put("Classe énergétique", NomColonne.CLASSE_ENERGETIQUE);
		    put("Actions", null);
		}};
	private String columnSorted = columnNames[0];
	private boolean isAscending = true;
	
    private int currentPage = 1;
    private int totalPages = 1;
    private List<String> numPageDisplayed; //String pour inclure "..."
    
	private BatimentResponse[] batimentsResp;
	private int nbElementsOnPage; //cb d'éléments sur la page actuelle
	
	private String searchInput = "";
	private String classEnergySelect = "Tous";
	private String actionName;
	
	private String path;
	
	@Override
	public void validate() {
		boolean isAscendingContext = Boolean.valueOf(ServletActionContext.getRequest().getParameter("isAscending"));
		String columnSortedContext = (String) ServletActionContext.getRequest().getParameter("sortBy");
		String currentPageContext = ServletActionContext.getRequest().getParameter("page");
		if (columnSortedContext != null && currentPageContext != null) {
			this.searchInput = ServletActionContext.getRequest().getParameter("search");
			this.classEnergySelect = ServletActionContext.getRequest().getParameter("class");
			this.currentPage = Integer.parseInt(currentPageContext);
			this.columnSorted = convertHtmlString(columnSortedContext);
			this.isAscending = isAscendingContext;
		}
    }

    
    public String execute() throws Exception {
    	path = ServletActionContext.getRequest().getContextPath();
    	btdg = (BatimentTDG) ServletActionContext.getServletContext().getAttribute("btdg");
		if (actionName != null && actionName.contains("Supprimer")) {
			try {
				int idBatiment = Integer.parseInt(actionName.split("Supprimer")[1]);
				btdg.delete(btdg.findById(idBatiment));
			} catch (Exception e) {
				System.out.println(e);
			}
			actionName = "Supprimer";
		}
        ClasseEnergetique[] classeEnergArr =  "Tous".equals(this.classEnergySelect) ? null : 
        	new ClasseEnergetique[]{ ClasseEnergetique.valueOf(this.classEnergySelect) };
    	PageBatimentRequest pageBatimentRequest = new PageBatimentRequest(this.currentPage - 1, 
    			this.isAscending, mapColumnNames.get(this.columnSorted), 
    			this.searchInput, classeEnergArr);
		totalPages = btdg.getTotalNbBatiments(pageBatimentRequest) == 0 ? 0 : btdg.getTotalNbBatiments(pageBatimentRequest)
				/ MAX_ELEMENTS_PER_PAGE + 1;
		setPagination();
		PageBatimentResponse pageBatimentResponse = btdg.getPageBatiments(pageBatimentRequest);
		batimentsResp = pageBatimentResponse.getBatimentsResp();
		nbElementsOnPage = pageBatimentResponse.getNbElements();
		return actionName == null ? SUCCESS : ActionManager.searchFormSuccessResponse.get(actionName);
    }

    public BatimentResponse[] getBatimentsResp() {
        return batimentsResp;
    }
    public String[] getColumnNames() {
    	return columnNames;
    }
    public String getColumnSorted() {
    	return columnSorted;
    }
    public boolean getIsAscending() {
    	return isAscending;
    }
    public List<String> getNumPageDisplayed() {
    	return numPageDisplayed;
    }
    public int getCurrentPage() {
    	return currentPage;
    }
    
    public String getSearchInput() {
    	return searchInput;
    }
    public void setSearchInput(String searchInput) {
    	this.searchInput = searchInput;
    }
    public String getClassEnergySelect() {
        return classEnergySelect;
    }
    public void setClassEnergySelect(String classEnergySelect) {
        this.classEnergySelect = classEnergySelect;
    }
    
    public void setActionName(String actionName) {
        this.actionName = actionName;
    }
    public String getPath() {
    	return this.path;
    }
    
    private void setPagination() {
    	if (totalPages <= 0) return;
    	numPageDisplayed = new ArrayList<>();
        int startPage = 1;
        int endPage = totalPages;
        
        if (totalPages > MAX_PAGES_DISPLAYED) {
            startPage = Math.max(currentPage - (MAX_PAGES_DISPLAYED / 2), 1);
            endPage = startPage + MAX_PAGES_DISPLAYED - 1;

            if (endPage > totalPages) {
                endPage = totalPages;
                startPage = endPage - MAX_PAGES_DISPLAYED + 1;
            }
        }
        if (startPage > 1) {
        	numPageDisplayed.add("1");
            if (startPage > 2) {
            	numPageDisplayed.add("...");
            }
        }
        for (int i = startPage; i <= endPage; i++) {
        	numPageDisplayed.add(String.valueOf(i));
        }
        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
            	numPageDisplayed.add("...");
            }
            numPageDisplayed.add(String.valueOf(totalPages));
        }
	}
    
    private String convertHtmlString(String input) {
        input = input.replaceAll("&eacute;", "é");
        input = input.replaceAll("&agrave;", "à");
        return input;
    }
}
