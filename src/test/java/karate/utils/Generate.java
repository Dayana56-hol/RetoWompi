package karate.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class Generate {
    public static String generateSHA256Hash( String reference, int amount_in_cents, String currency, String integrity_key) {
        try {
            String cadenaConcatenada = reference + amount_in_cents + currency + integrity_key;
            // Create a MessageDigest instance for SHA-256
            MessageDigest digest = MessageDigest.getInstance("SHA-256");

            // Perform the hash computation
            byte[] encodedhash = digest.digest(cadenaConcatenada.getBytes());

            // Convert byte array into a hexadecimal string
            StringBuilder hexString = new StringBuilder();
            for (byte b : encodedhash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }


    public static String generarCodigo() {
        Random random = new Random();
        StringBuilder codigo = new StringBuilder();

        // Parte fija "sk8"
        codigo.append("sk8-");

        // Generamos el primer bloque de 4 caracteres alfanuméricos
        codigo.append(generarBloqueAleatorio(random, 4)).append("-");

        // Generamos el segundo bloque de 4 caracteres alfanuméricos
        codigo.append(generarBloqueAleatorio(random, 4)).append("-");

        // Generamos el tercer bloque de 4 caracteres alfanuméricos
        codigo.append(generarBloqueAleatorio(random, 4));

        return codigo.toString();
    }

    // Método para generar un bloque de caracteres aleatorios
    private static String generarBloqueAleatorio(Random random, int longitud) {
        StringBuilder bloque = new StringBuilder();
        String caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; // caracteres alfanuméricos
        for (int i = 0; i < longitud; i++) {
            int indice = random.nextInt(caracteres.length());
            bloque.append(caracteres.charAt(indice));
        }
        return bloque.toString();
    }
}
