package com.venzura.utils;

import org.mindrot.jbcrypt.BCrypt;

public class Passwordhash {
    // Hash a password using BCrypt
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));  // 12 is the work factor
    }

    // Verify a password (compare entered password with stored hash)
    public static boolean checkPassword(String enteredPassword, String storedHash) {
        return BCrypt.checkpw(enteredPassword, storedHash);
    }
}
