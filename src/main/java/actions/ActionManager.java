package actions;

import java.util.HashMap;
import java.util.Map;

import com.opensymphony.xwork2.ActionSupport;

public class ActionManager extends ActionSupport {

	public final static Map<String, String> searchFormSuccessResponse = new HashMap<>() {{
			put("Rechercher", "rechercherSuccess");
			put("Formulaire de recherche", "goToFormSuccess");
			put("Ajout de données", "goToAddDataSuccess");
			put("Carte", "goToMapSuccess");
			put("Supprimer", "deleteSuccess");
		}};
		
		public final static Map<String, String> mapSuccessResponse = new HashMap<>() {{
			put("Formulaire de recherche", "goToFormSuccess");
			put("Ajout de données", "goToAddDataSuccess");
			put("Carte", "goToMapSuccess");
			put("Rechercher par classe", "rechercherClasseMapSuccess");
			put("Rechercher par adresse", "rechercherAdresseMapSuccess");
		}};

}
