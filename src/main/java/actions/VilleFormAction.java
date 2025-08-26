package actions;

import forms.DPEForm;
import forms.VilleForm;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.opensymphony.xwork2.ActionSupport;
import ilidpe.persistence.*;
import org.apache.struts2.ServletActionContext;


public class VilleFormAction extends ActionSupport {
    private VilleForm villeForm;
    private final CodePostalTDG cptdg;
    private final VilleTDG vtdg;
    private final RueTDG rtdg;
    private List<Rue> rues;
    private final static String FAILURE = "failure";
    public VilleFormAction() {
        cptdg = (CodePostalTDG) ServletActionContext.getServletContext().getAttribute("cptdg");
        vtdg = (VilleTDG) ServletActionContext.getServletContext().getAttribute("vtdg");
        rtdg = (RueTDG) ServletActionContext.getServletContext().getAttribute("rtdg");
        try {
			setRues(rtdg.selectWhere("ID >= 0"));
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }
    public boolean loadForEdit() {
        String idParameter = ServletActionContext.getRequest().getParameter("id");
        if (idParameter != null) {
            long id = Long.parseLong(idParameter);
            villeForm = new VilleForm();
            try {
				Ville v = vtdg.findById(id);
				if (v == null) return false;
				villeForm.setcPostal(v.getcPostal().getCode());
				villeForm.setNom(v.getNom());
				List<Integer> idRues = new ArrayList<Integer>();
				for (Rue r:v.getRues()) {
					idRues.add((int) r.getId());
				}
				villeForm.setIdRues(idRues);
				villeForm.setId(id);
			} catch (SQLException e) {
				return false;
			}
        }
        return true;
    }
    public String execute() {
    	if (villeForm != null) {
    		try {
    			Ville v;
    			CodePostal cp = new CodePostal(villeForm.getcPostal());
                if (cptdg.selectWhere("CODE LIKE ?", cp.getCode()).isEmpty()) {
                    cp = cptdg.insertIntoDB(cp);
                }
                else {
                    cp = cptdg.selectWhere("CODE LIKE ?", cp.getCode()).get(0);
                }
                String nom = villeForm.getNom();
		        List<Rue> ruesVille = new ArrayList<Rue>();
            	for (Integer id:villeForm.getIdRues()) {
            		Rue r = rtdg.findById(id);
            		ruesVille.add(r);
            	}
		        if (villeForm.getId() != null) {
		        	v = vtdg.findById(villeForm.getId());
		        	v.setcPostal(cp);
		        	v.setRues(ruesVille);
		        	v.setNom(nom);
		        	vtdg.update(v);
		        }
		        else {
		        	v = new Ville(cp, nom, ruesVille);
		        	vtdg.insert(v);
		        }
			} catch (SQLException e) {
				addActionError("Une erreur s'est produite lors du traitement de votre requête veuillez recommencer");
				e.printStackTrace();
				return FAILURE;
			}
    		villeForm = null;
    	}
    	else {
    		if (!loadForEdit()) {
    			addActionError("Une erreur s'est produite lors du chargement des données veuillez recommencer");
    			return ERROR;
    		}
    	}
        return SUCCESS;
    }
    @Override
    public void validate() {
        if (villeForm != null) {
            if (villeForm.getNom() == null || villeForm.getNom().equals("")) {
                addFieldError("villeForm.nom", "Le nom ne doit pas être vide");
            }
            if (villeForm.getcPostal() == null || villeForm.getcPostal().length() != 5) {
            	addFieldError("villeForm.cPostal","Le code postal doit être constitué de 5 caractères");
            }
            try {
            	for (Integer id:villeForm.getIdRues()) {
            		if (rtdg.findById(id) == null ) {
            			addFieldError("villeForm.idRues", "La rue n'existe pas");
            		}
            	}
			} catch (SQLException e) {
				addFieldError("villeForm.idRues", "La rue n'existe pas");
			}
        }
    }
	public VilleForm getVilleForm() {
		return villeForm;
	}
	public void setVilleForm(VilleForm villeForm) {
		this.villeForm = villeForm;
	}
	public List<Rue> getRues() {
		return rues;
	}
	public void setRues(List<Rue> rues) {
		this.rues = rues;
	}
}

