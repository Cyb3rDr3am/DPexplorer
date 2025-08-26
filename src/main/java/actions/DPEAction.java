package actions;

import forms.DPEForm;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.opensymphony.xwork2.ActionSupport;
import ilidpe.persistence.*;
import org.apache.struts2.ServletActionContext;


public class DPEAction extends ActionSupport {
    private DPEForm dpeForm;
    private List<CodePostal> codePostals;
    private List<String> classeEnergetiqueList;
    private List<Ville> villes;
    private List<Rue> rues;
    private final CodePostalTDG cptdg;
    private final VilleTDG vtdg;
    private final RueTDG rtdg;
    private final BatimentTDG btdg;
    private final DiagnosticTDG dtdg;
    private final String path;
    private final static String FAILURE = "failure";
    public DPEAction() {
    	path = ServletActionContext.getServletContext().getContextPath();
    	villes = new ArrayList<Ville>();
    	rues = new ArrayList<Rue>();
        classeEnergetiqueList = new ArrayList<>();
        for (ClasseEnergetique ce : ClasseEnergetique.values()) {
            classeEnergetiqueList.add(ce.toString());
        }
        cptdg = (CodePostalTDG) ServletActionContext.getServletContext().getAttribute("cptdg");
        vtdg = (VilleTDG) ServletActionContext.getServletContext().getAttribute("vtdg");
        rtdg = (RueTDG) ServletActionContext.getServletContext().getAttribute("rtdg");
        btdg = (BatimentTDG) ServletActionContext.getServletContext().getAttribute("btdg");
        dtdg = (DiagnosticTDG) ServletActionContext.getServletContext().getAttribute("dtdg");
        try {
			codePostals = cptdg.selectWhere("ID >= 0");
		} catch (SQLException e) {
			e.printStackTrace();
		}


    }
    public boolean loadForEdit() {
        String idParameter = ServletActionContext.getRequest().getParameter("id");
        if (idParameter != null) {
            int id = Integer.parseInt(idParameter);
            dpeForm = new DPEForm();
            try {
				Batiment b = btdg.findById(id);
				if (b == null) return false;
				dpeForm.setAnneeConstruction(b.getAnneeConstruction());
				dpeForm.setNumeroVoie(b.getNumero());
				dpeForm.setConsommation(b.getDiagnostic().getConsommation());
				dpeForm.setClasseEnergetique(b.getDiagnostic().getCEnergetique());
				dpeForm.setIdCodePostal((int) b.getVille().getcPostal().getId());
				dpeForm.setIdVille((int) b.getVille().getId());
				dpeForm.setIdRue((int) b.getRue().getId());
				dpeForm.setId((int) b.getId());
			} catch (SQLException e) {
				return false;
			}
        }
        return true;
    }
    public String execute() {
    	if (dpeForm != null) {
    		System.out.println(dpeForm.getClasseEnergetique());
    		try {
				CodePostal cp = cptdg.findById(dpeForm.getIdCodePostal());
				Ville v = vtdg.findById(dpeForm.getIdVille());
				Rue r = rtdg.findById(dpeForm.getIdRue());
				Diagnostic d = new Diagnostic(dpeForm.getClasseEnergetique(), dpeForm.getConsommation());
                dtdg.insertIntoDB(d);
				Batiment b;
		        if (dpeForm.getId() != null) {
		        	b = btdg.findById(dpeForm.getId());
		        	b.setAnneeConstruction(dpeForm.getAnneeConstruction());
		        	b.setNumero(dpeForm.getNumeroVoie());
		        	b.setCodePostal(cp);
		        	b.setVille(v);
		        	b.setRue(r);
		        	b.setDiagnostic(d);
		            System.out.println(b);
		            btdg.update(b);
		        }
		        else {
		        	b = new Batiment(dpeForm.getNumeroVoie(), dpeForm.getAnneeConstruction(), cp, v, r, d);
		        	btdg.insert(b);
		        }
			} catch (SQLException e) {
				addActionError("Une erreur s'est produite lors du traitement de votre requête veuillez recommencer");
				e.printStackTrace();
				return FAILURE;
			}
    		dpeForm = null;
    	}
    	else {
    		if (!loadForEdit()) {
    			addActionError("Une erreur s'est produite lors du chargement des données veuillez recommencer");
    			return FAILURE;
    		}
    	}
        return SUCCESS;
    }

    // Getter et Setter pour dpeForm
    public DPEForm getDpeForm() {
        return dpeForm;
    }

    public void setDpeForm(DPEForm dpeForm) {
        this.dpeForm = dpeForm;
    }
    public List<String> getClasseEnergetiqueList() {
        return classeEnergetiqueList;
    }
	public List<CodePostal> getCodePostals() {
		return codePostals;
	}
    @Override
    public void validate() {
        if (dpeForm != null) {
        	if (dpeForm.getClasseEnergetique() == null) {
        		addFieldError("dpeForm.classeEnergetique","Veuillez choisir une classe énergétique");
        	}
            if (dpeForm.getAnneeConstruction() == null || dpeForm.getAnneeConstruction() < 0) {
                addFieldError("dpeForm.anneeConstruction", "L'année de construction doit être supérieure ou égale à 0.");
            }
            if (dpeForm.getNumeroVoie() == null || dpeForm.getNumeroVoie() < 0) {
                addFieldError("dpeForm.numeroVoie", "Le numéro de voie doit être supérieure ou égale à 0.");
            }
            try {
				if (dpeForm.getIdCodePostal() == null || cptdg.findById(dpeForm.getIdCodePostal()) == null ) {
	                addFieldError("dpeForm.idCodePostal", "Le code postal n'existe pas");
				}
			} catch (SQLException e) {
				addFieldError("dpeForm.idCodePostal", "Le code postal n'existe pas");
			}
            try {
				if (dpeForm.getIdVille() == null || vtdg.findById(dpeForm.getIdVille()) == null ) {
	                addFieldError("dpeForm.idVille", "La ville n'existe pas");
				}
			} catch (SQLException e) {
				addFieldError("dpeForm.idVille", "La ville n'existe pas");
			}
            try {
				if (dpeForm.getIdRue() == null || rtdg.findById(dpeForm.getIdRue() ) == null ) {
	                addFieldError("dpeForm.idRue", "La rue n'existe pas");
				}
			} catch (SQLException e) {
				addFieldError("dpeForm.idRue", "La rue n'existe pas");
			}
        }
    }
	public List<Ville> getVilles() {
		return villes;
	}
	public String getPath() {
		return path;
	}
	public List<Rue> getRues() {
		return rues;
	}
}

