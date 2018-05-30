package user

enum City {
    BUENOS_AIRES("Bs As"), ROSARIO("Ro"), PUERTO_MADRYN("Pto Mdn")

    String abbreviation

    City(String abbreviation){
        this.abbreviation = abbreviation
    }
}