package karate.transactions;


import com.intuit.karate.junit5.Karate;

public class TransactionsRunner {
    private static final String PROJECT = "transactions";

    @Karate.Test
    Karate transactions() {return Karate.run(PROJECT).relativeTo(getClass());}

}
