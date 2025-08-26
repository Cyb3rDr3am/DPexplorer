package listeners;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import ilidpe.persistence.*;
import com.opencsv.CSVReaderHeaderAware;
import com.opencsv.exceptions.CsvException;
import java.util.Arrays;
import java.util.Map;


import java.util.List;
import java.sql.SQLException;
import ili.jai.abstracttdg.TDGRegistry;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.InputStream;
import java.io.Reader;
import java.net.URISyntaxException;
import java.net.URL;
import java.io.FileNotFoundException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;

@WebListener
public class ServerLaunchListener implements ServletContextListener {
    private static CodePostalTDG cptdg;
    private static VilleTDG vtdg;
    private static RueTDG rtdg;
    private static BatimentTDG btdg;
    private static DiagnosticTDG dtdg;
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
			createTable(sce);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

    private static void createTable() throws SQLException  {
        cptdg.createTable();
        rtdg.createTable();
        vtdg.createTable();
        dtdg.createTable();
        btdg.createTable();
    }
    private void initializeData(ServletContextEvent sce) throws FileNotFoundException{
        InputStream inputStream = getClass().getClassLoader().getResourceAsStream("data.csv");
        Reader file = new InputStreamReader(inputStream);
        try (CSVReaderHeaderAware reader = new CSVReaderHeaderAware(file)) {
            createTable();
            Map<String, String> values;
            values = reader.readMap();
            while ((values = reader.readMap()) != null) {
                String dpt = values.get("N°_département_(BAN)");
                if (!dpt.equals("59") && !dpt.equals("62")) {
                    continue;
                }
                String codePostal = values.get("Code_postal_(BAN)");
                String etiquetteDPE = values.get("Etiquette_DPE");
                String anneConstruction = values.get("Année_construction");
                String numeroVoie = values.get("N°_voie_(BAN)");
                if (anneConstruction.equals("")) {
                    continue;
                }
                if (numeroVoie.equals("")) {
                    continue;
                }
                try {
                    Integer.parseInt(numeroVoie);
                } catch (NumberFormatException e) {
                    continue;
                }
                String rue = values.get("Nom__rue_(BAN)");
                String ville = values.get("Nom__commune_(BAN)");
                String conso = values.get("Conso_5_usages/m²_é_finale");

                CodePostal cp = new CodePostal(codePostal);
                if (cptdg.selectWhere("CODE LIKE ?", cp.getCode()).isEmpty()) {
                    cp = cptdg.insertIntoDB(cp);
                }
                else {
                    cp = cptdg.selectWhere("CODE LIKE ?", cp.getCode()).get(0);
                }
                Rue r = new Rue(rue);
                if (rtdg.selectWhere("NOM LIKE ?", r.getNom()).isEmpty()) {
                    r = rtdg.insertIntoDB(r);
                }
                else {
                    r = rtdg.selectWhere("NOM LIKE ?", r.getNom()).get(0);
                }
                Ville v = new Ville(cp, ville);
                v.appendRues(r);
                List<Ville> v2 = vtdg.selectWhere("NOM LIKE ?", v.getNom());
                if (v2.isEmpty()) {
                    v = vtdg.insertIntoDB(v);
                } else {
                    v = v2.get(0);
                    if (!v.getRues().contains(r)) {
                    	v.appendRues(r);
                    }
                    else {
                    	System.out.println("ici");
                    }
                    vtdg.updateIntoDB(v);
                }
                Diagnostic d = new Diagnostic(ClasseEnergetique.valueOf(etiquetteDPE), (int) Double.parseDouble(conso));
                dtdg.insertIntoDB(d);
                Batiment b = new Batiment(Integer.parseInt(numeroVoie), Integer.parseInt(anneConstruction), cp, v, r, d);            
                btdg.insertIntoDB(b);
            }
        } catch (IOException | CsvException | SQLException e) {
            e.printStackTrace();
        }
    }
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Handle cleanup if necessary
    }
    public void createTable(ServletContextEvent sce) throws FileNotFoundException {
        try {
			Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
        /**if (!Files.exists(folderPath)) {
        }*/
//        File folder = new File("./DPEDB");
        File folder = new File("./DPEDB");
        ServletContext context = sce.getServletContext();
        String cheminDossier = context.getRealPath("/");
        System.out.println("Chemin du dossier du projet : " + cheminDossier);
        boolean exist = false;
        if (folder.exists() && folder.isDirectory()) {
            System.out.println("Folder DPEDB exists.");
            exist = true;
        }
        cptdg = TDGRegistry.findTDG(CodePostal.class);
        rtdg = TDGRegistry.findTDG(Rue.class);
        vtdg = TDGRegistry.findTDG(Ville.class);
        dtdg = TDGRegistry.findTDG(Diagnostic.class);
        btdg = TDGRegistry.findTDG(Batiment.class);
        if (!exist) {
        	initializeData(sce);
        }

        sce.getServletContext().setAttribute("btdg",btdg);
        sce.getServletContext().setAttribute("cptdg",cptdg);
        sce.getServletContext().setAttribute("vtdg", vtdg);
        sce.getServletContext().setAttribute("rtdg", rtdg);
        sce.getServletContext().setAttribute("dtdg", dtdg);


        System.out.println("base created");
    }
}