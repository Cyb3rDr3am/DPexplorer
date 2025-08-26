package forms;

import java.util.List;

import ilidpe.persistence.Rue;

public class VilleForm {
	private Long id;
	private String cPostal;
	private String nom;
	private List<Integer> idRues;
	public String getcPostal() {
		return cPostal;
	}
	public void setcPostal(String cPostal) {
		this.cPostal = cPostal;
	}
	public String getNom() {
		return nom;
	}
	public void setNom(String nom) {
		this.nom = nom;
	}
	public List<Integer> getIdRues() {
		return idRues;
	}
	public void setIdRues(List<Integer> idRues) {
		this.idRues = idRues;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
}
