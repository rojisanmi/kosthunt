package models;

public class Room {
    private int id;
    private String number;
    private String type;
    private String kostName;
    private int kostId;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNumber() { return number; }
    public void setNumber(String number) { this.number = number; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public int getKostId() { return kostId; }
    public void setKostId(int kostId) { this.kostId = kostId; }
    public String getKostName() { return kostName; }
    public void setKostName(String kostName) { this.kostName = kostName; }
}