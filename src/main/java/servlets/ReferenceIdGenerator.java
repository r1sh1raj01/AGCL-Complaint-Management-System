package servlets;

import java.util.HashMap;
import java.util.Map;

public class ReferenceIdGenerator {
    
    private static Map<String, String> departmentShortForms = new HashMap<>();

    static {
        departmentShortForms.put("Projects & Planning", "P&P");
        departmentShortForms.put("Business Development (BD)", "BD");
        departmentShortForms.put("Pipeline", "PL");
        departmentShortForms.put("Cathodic Protection (CP)", "CP");
        departmentShortForms.put("Instrumentation & TGG", "I&TGG");
        departmentShortForms.put("SCADA", "SCADA");
        departmentShortForms.put("Compressor", "COMP");
        departmentShortForms.put("City Gas Distribution (CGD)", "CGD");
        departmentShortForms.put("Retail Business & Coordination", "RB&C");
        departmentShortForms.put("Health Safety & Environment (HSE)", "HSE");
        departmentShortForms.put("Electrical", "ELEC");
        departmentShortForms.put("Civil", "CIV");
        departmentShortForms.put("Contracts & Procurements (C&P)", "C&P");
        departmentShortForms.put("Human Resource and Admin (HR&A)", "HR&A");
        departmentShortForms.put("Land", "LAND");
        departmentShortForms.put("Medical", "MED");
        departmentShortForms.put("Transport", "TRANS");
        departmentShortForms.put("Company Secretary", "CS");
        departmentShortForms.put("Security & Vigilance", "S&V");
        departmentShortForms.put("Finance & Accounts (F&A)", "F&A");
        departmentShortForms.put("Information Technology", "IT");
    }

    public static String generateReferenceId(String departmentName) {
        String shortForm = departmentShortForms.get(departmentName);
        if (shortForm == null) {
            throw new IllegalArgumentException("Invalid department name: " + departmentName);
        }
        return shortForm + "-" + System.currentTimeMillis();
    }

    public static void main(String[] args) {
        // Example usage
        String departmentName = "Projects & Planning";
        String refId = generateReferenceId(departmentName);
        System.out.println("Generated Reference ID: " + refId);
    }
}
