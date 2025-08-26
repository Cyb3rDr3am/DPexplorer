package forms;
import ilidpe.persistence.*;
public class DPEForm {
	private Integer id;
    private Integer idCodePostal;
    private Integer idVille;
    private Integer idRue;
    private ClasseEnergetique classeEnergetique;
    private Integer consommation;
    private Integer numeroVoie;
    private Integer anneeConstruction;

    public Integer getIdCodePostal() {
        return this.idCodePostal;
    }

    public void setIdCodePostal(Integer idCodePostal) {
        this.idCodePostal = idCodePostal;
    }

	public Integer getIdVille() {
		return idVille;
	}

	public void setIdVille(Integer idVille) {
		this.idVille = idVille;
	}
	public Integer getIdRue() {
		return idRue;
	}

	public void setIdRue(Integer idRue) {
		this.idRue = idRue;
	}
    public ClasseEnergetique getClasseEnergetique() {
        return classeEnergetique;
    }

    public void setClasseEnergetique(ClasseEnergetique classeEnergetique) {
        this.classeEnergetique = classeEnergetique;
    }

    public Integer getConsommation() {
        return consommation;
    }

    public void setConsommation(Integer consommation) {
        this.consommation = consommation;
    }

    public Integer getNumeroVoie() {
        return numeroVoie;
    }

    public void setNumeroVoie(Integer numeroVoie) {
        this.numeroVoie = numeroVoie;
    }

    public Integer getAnneeConstruction() {
        return anneeConstruction;
    }

    public void setAnneeConstruction(Integer anneeConstruction) {
        this.anneeConstruction = anneeConstruction;
    }

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
}
