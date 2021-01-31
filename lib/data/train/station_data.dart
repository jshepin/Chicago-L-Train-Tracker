import 'package:CTA_Tracker/pages/lines/lines.dart';
import '../classes.dart';

List<String> getDirection(String name, {bool addTag}) {
  if (addTag != null && addTag) {
    switch (name) {
      case "Red":
        return ["All", "Howard", "95th/Dan Ryan"];
      case "Blue":
        return ["All", "O’Hare", "Forest Park"];
      case "Brown":
        return ["All", "Kimball", "Loop"];
      case "Green":
        return ["All", "Harlem/Lake", "Cottage Grove", "63rd"];
      case "Orange":
        return ["All", "Loop", "Midway"];
      case "Purple":
        return ["All", "Linden", "Howard/Loop"];
      case "Pink":
        return ["All", "Loop", "54th/Cermak"];
      case "Yellow":
        return ["All", "Skokie", "Howard"];
      default:
        return ["unknown"];
    }
  } else {
    switch (name) {
      case "Red":
        return ["Howard", "95th/Dan Ryan"];
      case "Blue":
        return ["O’Hare", "Forest Park"];
      case "Brown":
        return ["Kimball", "Loop"];
      case "Green":
        return ["Harlem/Lake", "Cottage Grove", "63rd"];
      case "Orange":
        return ["Loop", "Midway"];
      case "Purple":
        return ["Linden", "Howard/Loop"];
      case "Pink":
        return ["Loop", "54th/Cermak"];
      case "Yellow":
        return ["Skokie", "Howard"];
      default:
        return ["unknown"];
    }
  }
}

convertLongColor(String a) {
  //convert abbreviated color into long for. ex: brn -> brown
  switch (a) {
    case "Brown":
      return "Brn";
    case "Green":
      return "G";
    case "Orange":
      return "Org";
    case "Purple":
      return "P";
    case "Yellow":
      return "Y";
    default:
      return a;
  }
}

convertShortColorDisplay(String a) {
  //convert abbreviated color into long for. ex: brn -> brown
  switch (a) {
    case "Brn":
      return "Brown";
    case "G":
      return "Green";
    case "Org":
      return "Orange";
    case "P":
      return "Purple";
    case "Y":
      return "Yellow";
    case "Red":
      return "Red";
    case "Blue":
      return "Blue";
    case "Pink":
      return "Pink";
    default:
      return a;
  }
}

convertShortColor(String a) {
  //convert abbreviated color into long for. ex: brn -> brown
  switch (a) {
    case "Brn":
      return "Brown";
    case "G":
      return "Green";
    case "Org":
      return "Orange";
    case "P":
      return "Purple";
    case "Y":
      return "Yellow";
    default:
      return a;
  }
}

List<String> getLineOrders(String color) {
  switch (color) {
    case "Red":
      return [
        "40900", //howard
        "41190", //Jarvis
        "40100", //Morse
        "41300", //Loyola
        "40880"
            "40760", //granville
        "40760", //granville
        "40880",
        "41380", //Thorndale
        "40340", //Bryn Mawr
        "41200", //Berwyn
        "40770", //Argyle
        "40540", //Lawrence
        "40080", //Wilson
        "41420", //Sheridan
        "41320", //Addison
        "41220", //Belmont
        "40650", //Fullerton
        "40630", //North/Clybourn
        "41450", //chicago
        "40710", //Clark/Division
        "40330", //Chicago
        "41660", //Grand
        "41090", //Lake
        "40560", //Monroe
        "41490", //Jackson
        "41400", //Harrison
        "41000", //Roosevelt
        "40190", //Cermak-Chinatown
        "41230", //Sox-35th
        "41170", //47th
        "40910", //63rd
        "40990", //69th
        "40240", //79th
        "41430", //87th
        "40450" //95th/Dan Ryan
      ];
    case "Purple":
      return [
        "41050", //Linden
        "41250", //Central
        "40400", //Noyes
        "40520", //Foster
        "40050", //Davis
        "40690", //Dempster
        "40270", //Main
        "40840", //South Blvd
        "40900" //Howard
      ];
    case "Blue":
      return [
        "40890", //O'Hare
        "40820", //Rosemont
        "40230", //Cumberland
        "40750", //Harlem
        "41280", //Jefferson Park
        "41330", //Montrose
        "40550", //Irving Park
        "41240", //Addison
        "40060", //Belmont
        "41020", //Logan Square
        "40570", //California
        "40670", //Western (o'hare )
        "40590", //Damen
        "40320", //Division
        "41410", //Chicago
        "40490", //Grand
        "40380", //Clark/Lake
        "40370", //Washington
        "40790", //Monroe
        "40070", //Jackson
        "41340", //LaSalle
        "40430", //Clinton
        "40350", //UIC-Halsted
        "40470", //Racine
        "40810", //Illinois Medical District
        "40220", //Western (forest park)
        "40250", //Kedzie-Homan
        "40920", //Pulaski
        "40970", //Cicero
        "40010", //Austin
        "40180", //Oak Park
        "40980", //Forest Park
        "40390", //Forest Park
      ];
    case "Pink":
      return [
        "40580", //54th/Cermak
        "40420", //Cicero
        "40600", //Kostner
        "40150", //Pulaski
        "40780", //Central Park
        "41040", //Kedzie
        "40440", //California
        "40740", //Western
        "40210", //Damen
        "40830", //18th
        "41030", //Polk
        "40170", //Ashland
        "41510", //Morgan
        "41160", //Clinton
        "40380", //Clark/Lake
        "40260", //State/Lake
        "41700", //Washington/Wabash
        "40680", //Adams/Wabash
        "40850", //Harold Washington Library-State/Van Buren
        "40160", //LaSalla/Van Buren
        "40040", //Quincy
        "40730", //Washington/Wells
      ];
    case "Green":
      return [
        "40020", //Harlem/Lake
        "41350", //Oak Park
        "40610", //Ridgeland
        "41260", //Austin
        "40280", //Central
        "40700", //Laramie
        "40480", //Cicero
        "40030", //Pulaski
        "41670", //Conservatory-Central Park DriveAccessible station
        "41070", //Kedzie
        "41360", //California
        "40170", //Ashland
        "41510", //Morgan
        "41160", //Clinton
        "40380", //Clark/Lake
        "40260", //State/Lake
        "41700", //Washington/Wabash
        "40680", //Adams/Wabash
        "41400", //Roosevelt
        "41690", //Cermak-McCormick Place
        "41120", //35th-Bronzeville-IIT
        "40300", //Indiana
        "41270", //43rd
        "41080", //47th
        "40130", //51st
        "40510", //Garfield
        // "41140", //King Drive
        // "40720", //Cottage Grove
        "40940", //Halsted
        "40290", //Ashlan/63rd
      ];
    case "Brown":
      return [
        "41290", //Kimball
        "41180", //Kedzie
        "40870", //Francisco
        "41010", //Rockwell
        "41480", //Western
        "40090", //Damen
        "41500", //Montrose
        "41460", //Irving Park
        "41440", //Addison
        "41310", //Paulina
        "40360", //Southport
        "41320", //Belmont
        "41210", //Wellington
        "40530", //Diversey
        "41220", //Fullerton
        "40660", //Armitage
        "40800", //Sedgwick
        "40710", //Chicago
        "40460", //Merchandise Mart
        "40730", //Washington/Wells
        "40040", //Quincy
        "40160", //LaSalle/Van Buren
        "40850", //Harold Washington Library-State/Van Buren
        "40680", //Adams/Wabash
        "41700", //Washington/Wabash
        "40260", //State/Lake
        "40380", //Clark/Lake
      ];
    case "Orange":
      return [
        "40930", //Midway
        "40960", //Pulaski
        "41150", //Kedzie
        "40310", //Western
        "40120", //35th/Archer
        "41060", //Ashland
        "41130", //Halsted
        "41400", //Roosevelt
        "40850", //Harold Washington Library-State/Van Buren
        "40160", //LaSalle/Van Buren
        "40040", //Quincy
        "40730", //Washington/Wells
        "40380", //Clark/Lake
        "40260", //State/Lake
        "41700", //Washington/Wabash
        "40680", //Adams/Wabash
      ];
    case "Yellow":
      return [
        "40140", //Dempster Skokie
        "41680", //Oakton-Skokie
        "40900", //Howard
      ];

    default:
      return [];
  }
}

List<Station> getStationData() {
  return [
    new Station("40010", "Austin", ["Blue"], "41.870851", "-87.776812", false, false),
    new Station("40020", "Harlem/Lake", ["Green"], "41.886848", "-87.803176", true, false),
    new Station("40030", "Pulaski", ["Green"], "41.885412", "-87.725404", true, false),
    new Station("40040", "Quincy", ["Brown", "Purple", "Pink", "Orange"], "41.878723", "-87.63374", true, false),
    new Station("40050", "Davis", ["Purple"], "42.04771", "-87.683543", true, false),
    new Station("40060", "Belmont", ["Blue"], "41.938132", "-87.712359", false, false),
    new Station("40070", "Jackson", ["Red", "Orange", "Pink", "Brown", "Purple", "Blue"], "41.878183", "-87.629296", true, false, pexp: true, note: "For free transfer to elevated lines: (Orange, Brown, Pink, Purple Express), exit station south and walk to Harold Washington Library-State/Van Buren station. Farecard required."),
    new Station("40080", "Sheridan", ["Red"], "41.953775", "-87.654929", false, false),
    new Station("40090", "Damen", ["Brown"], "41.966286", "-87.678639", true, false),
    new Station("40100", "Morse", ["Red"], "42.008362", "-87.665909", false, false),
    new Station("40120", "35th/Archer", ["Orange"], "41.829353", "-87.680622", true, true),
    new Station("40130", "51st", ["Green"], "41.80209", "-87.618487", true, false),
    new Station("40140", "Dempster-Skokie", ["Yellow"], "42.038951", "-87.751919", true, true),
    new Station("40150", "Pulaski", ["Pink"], "41.853732", "-87.724311", true, false),
    new Station("40160", "LaSalle/Van Buren", ["Brown", "Purple", "Pink", "Orange"], "41.8768", "-87.631739", false, false),
    new Station("40170", "Ashland", ["Green", "Pink"], "41.885269", "-87.666969", true, false),
    new Station("40180", "Oak Park", ["Blue"], "41.872108", "-87.791602", false, false),
    new Station("40190", "Sox-35th", ["Red"], "41.831191", "-87.630636", true, false),
    new Station("40210", "Damen", ["Pink"], "41.854517", "-87.675975", true, false),
    new Station("40220", "Western (Forest Park)", ["Blue"], "41.875478", "-87.688436", false, false),
    new Station("40230", "Cumberland", ["Blue"], "41.984246", "-87.838028", true, true),
    new Station("40240", "79th", ["Red"], "41.750419", "-87.625112", true, false),
    new Station("40250", "Kedzie-Homan", ["Blue"], "41.874341", "-87.70604", true, false),
    new Station("40260", "State/Lake", ["Green", "Brown", "Purple", "Pink", "Orange"], "41.88574", "-87.627835", false, false),
    new Station("40270", "Main", ["Purple"], "42.033456", "-87.679538", false, false),
    new Station("40280", "Central", ["Green"], "41.887389", "-87.76565", true, false),
    new Station("40290", "Ashland/63rd", ["Green"], "41.77886", "-87.663766", true, true),
    new Station("40300", "Indiana", ["Green"], "41.821732", "-87.621371", true, false),
    new Station("40310", "Western", ["Orange"], "41.804546", "-87.684019", true, true),
    new Station("40320", "Division", ["Blue"], "41.903355", "-87.666496", false, false),
    new Station("40330", "Grand", ["Red"], "41.891665", "-87.628021", true, false),
    new Station("40340", "Berwyn", ["Red"], "41.977984", "-87.658668", false, false),
    new Station("40350", "UIC-Halsted", ["Blue"], "41.875474", "-87.649707", true, false),
    new Station("40360", "Southport", ["Brown"], "41.943744", "-87.663619", true, false),
    new Station("40370", "Washington", ["Red", "Brown", "Orange", "Pink", "Purple", "Green", "Blue"], "41.883164", "-87.62944", false, false, note: "To transfer to Red Line trains, exit via Randolph-Washington exit and use mezzanine-level pedway through Block 37 Center to Red Line trains. Farecard required for free transfer to Red Line."),
    new Station("40380", "Clark/Lake", ["Green", "Brown", "Purple", "Pink", "Orange", "Blue"], "41.885737", "-87.630886", true, false),
    new Station("40390", "Forest Park", ["Blue"], "41.874257", "-87.817318", true, true),
    new Station("40400", "Noyes", ["Purple"], "42.058282", "-87.683337", false, false),
    new Station("40420", "Cicero", ["Pink"], "41.85182", "-87.745336", true, false),
    new Station("40430", "Clinton", ["Blue"], "41.875539", "-87.640984", false, false),
    new Station("40440", "California", ["Pink"], "41.854109", "-87.694774", true, false),
    new Station("40450", "95th/Ran Ryan", ["Red"], "41.722377", "-87.624342", true, false),
    new Station("40460", "Merchandise Mart", ["Brown", "Purple"], "41.888969", "-87.633924", true, false),
    new Station("40470", "Racine", ["Blue"], "41.87592", "-87.659458", false, false),
    new Station("40480", "Cicero", ["Green"], "41.886519", "-87.744698", true, false),
    new Station("40490", "Grand", ["Blue"], "41.891189", "-87.647578", false, false),
    new Station("40510", "Garfield", ["Green"], "41.795172", "-87.618327", true, true),
    new Station("40520", "Foster", ["Purple"], "42.05416", "-87.68356", false, false),
    new Station("40530", "Diversey", ["Brown", "Purple"], "41.932732", "-87.653131", true, false),
    new Station("40540", "Wilson", ["Red", "Purple"], "41.964273", "-87.657588", true, false),
    new Station("40550", "Irving Park", ["Blue"], "41.952925", "-87.729229", false, false),
    new Station("40560", "Jackson", ["Red", "Brown", "Orange", "Pink", "Purple", "Blue"], "41.878153", "-87.627596", true, false,
        pexp: true, note: "To connect to above groundlines for free (Orange, Brown, Pink, Purple Express), exit station south and walk to Harold Washington Library-State/Van Buren station. Farecard required. Predictions for those lines are not shown here."),
    new Station("40570", "California", ["Blue"], "41.921939", "-87.69689", false, false),
    new Station("40580", "54th/Cermak", ["Pink"], "41.85177331", "-87.75669201", true, true),
    new Station("40590", "Damen", ["Blue"], "41.909744", "-87.677437", false, false),
    new Station("40600", "Kostner", ["Pink"], "41.853751", "-87.733258", true, false),
    new Station("40610", "Ridgeland", ["Green"], "41.887159", "-87.783661", false, false),
    new Station("41690", "Cermak-McCormick", ["Green"], "41.853069", "-87.626289", true, false),
    new Station("40630", "Clark/Division", ["Red"], "41.90392", "-87.631412", true, false),
    new Station("41700", "Washington/Wabash", ["Green", "Brown", "Purple", "Pink", "Orange"], "41.882023", "-87.626098", true, false),
    new Station("40650", "North/Clybourn", ["Red"], "41.910655", "-87.649177", false, false),
    new Station("40660", "Armitage", ["Brown", "Purple"], "41.918217", "-87.652644", true, false),
    new Station(
      "40670",
      "Western (O'Hare)",
      ["Blue"],
      "41.916157",
      "-87.687364",
      true,
      false,
    ),
    new Station("40680", "Adams/Wabash", ["Green", "Brown", "Purple", "Pink", "Orange"], "41.879507", "-87.626037", false, false),
    new Station("40690", "Dempster", ["Purple"], "42.041655", "-87.681602", false, false),
    new Station("40700", "Laramie", ["Green"], "41.887163", "-87.754986", true, false),
    new Station("40710", "Chicago", ["Brown", "Purple"], "41.89681", "-87.635924", true, false),
    new Station("40720", "Cottage Grove", ["Green"], "41.780309", "-87.605857", true, false),
    new Station("40730", "Washington/Wells", ["Brown", "Purple", "Pink", "Orange"], "41.882695", "-87.63378", true, false),
    new Station("40740", "Western", ["Pink"], "41.854225", "-87.685129", true, false),
    new Station("40750", "Harlem (O'hare)", ["Blue"], "41.98227", "-87.8089", true, true),
    new Station("40760", "Granville", ["Red"], "41.993664", "-87.659202", true, false),
    new Station("40770", "Lawrence", ["Red"], "41.969139", "-87.658493", false, false),
    new Station("40780", "Central Park", ["Pink"], "41.853839", "-87.714842", true, false),
    new Station("40790", "Monroe", ["Blue"], "41.880703", "-87.629378", false, false),
    new Station("40800", "Sedgwick", ["Brown", "Purple"], "41.910409", "-87.639302", true, false),
    new Station("40810", "Medical District", ["Blue"], "41.875706", "-87.673932", true, false),
    new Station("40820", "Rosemont", ["Blue"], "41.983507", "-87.859388", true, true),
    new Station("40830", "18th", ["Pink"], "41.857908", "-87.669147", true, false),
    new Station("40840", "South Boulevard", ["Purple"], "42.027612", "-87.678329", false, false),
    new Station("40850", "Washington Library", ["Brown", "Purple", "Pink", "Orange"], "41.876862", "-87.628196", true, false),
    new Station("40870", "Francisco", ["Brown"], "41.966046", "-87.701644", true, false),
    new Station("40880", "Thorndale", ["Red"], "41.990259", "-87.659076", false, false),
    new Station("40890", "O'Hare", ["Blue"], "41.97766526", "-87.90422307", true, true, isAirport: true),
    new Station("40900", "Howard", ["Red", "Purple", "Yellow"], "42.019063", "-87.672892", true, true),
    new Station("40910", "63rd", ["Red"], "41.780536", "-87.630952", true, false),
    new Station("40920", "Pulaski", ["Blue"], "41.873797", "-87.725663", false, false),
    new Station("40930", "Midway", ["Orange"], "41.78661", "-87.737875", true, true, isAirport: true),
    new Station("40940", "Halsted", ["Green"], "41.778943", "-87.644244", true, false),
    new Station("40960", "Pulaski", ["Orange"], "41.799756", "-87.724493", true, true),
    new Station("40970", "Cicero", ["Blue"], "41.871574", "-87.745154", false, false),
    new Station("40980", "Harlem (Forest Park)", ["Blue"], "41.87349", "-87.806961", false, false),
    new Station("40990", "69th", ["Red"], "41.768367", "-87.625724", true, false),
    new Station("41000", "Cermak-Chinatown", ["Red"], "41.853206", "-87.630968", true, false),
    new Station("41010", "Rockwell", ["Brown"], "41.966115", "-87.6941", true, false),
    new Station("41020", "Logan Square", ["Blue"], "41.929728", "-87.708541", true, false),
    new Station("41030", "Polk", ["Pink"], "41.871551", "-87.66953", true, false),
    new Station("41040", "Kedzie", ["Pink"], "41.853964", "-87.705408", true, false),
    new Station("41050", "Linden", ["Purple"], "42.073153", "-87.69073", true, true),
    new Station("41060", "Ashland", ["Orange"], "41.839234", "-87.665317", true, false),
    new Station("41070", "Kedzie", ["Green"], "41.884321", "-87.706155", true, false),
    new Station("41080", "47th", ["Green"], "41.809209", "-87.618826", true, false),
    new Station("41090", "Monroe", ["Red"], "41.880745", "-87.627696", true, false),
    new Station("41120", "35th-Bronzeville-IIT", ["Green"], "41.831677", "-87.625826", true, false),
    new Station("41130", "Halsted", ["Orange"], "41.84678", "-87.648088", true, true),
    new Station("41140", "King Drive", ["Green"], "41.78013", "-87.615546", true, false),
    new Station("41150", "Kedzie", ["Orange"], "41.804236", "-87.704406", true, true),
    new Station("41160", "Clinton", ["Green", "Pink"], "41.885678", "-87.641782", true, false),
    new Station("41170", "Garfield", ["Red"], "41.79542", "-87.631157", true, false),
    new Station("41180", "Kedzie", ["Brown"], "41.965996", "-87.708821", true, false),
    new Station("41190", "Jarvis", ["Red"], "42.015876", "-87.669092", false, false),
    new Station("41200", "Argyle", ["Red"], "41.973453", "-87.65853", false, false),
    new Station("41210", "Wellington", ["Brown", "Purple"], "41.936033", "-87.653266", true, false),
    new Station("41220", "Fullerton", ["Brown", "Purple", "Red"], "41.925051", "-87.652866", true, false),
    new Station("41230", "47th", ["Red"], "41.810318", "-87.63094", true, false),
    new Station("41240", "Addison", ["Blue"], "41.94738", "-87.71906", true, false),
    new Station("41250", "Central", ["Purple"], "42.063987", "-87.685617", false, false),
    new Station("41260", "Austin", ["Green"], "41.887293", "-87.774135", false, false),
    new Station("41270", "43rd", ["Green"], "41.816462", "-87.619021", true, false),
    new Station("41280", "Jefferson Park", ["Blue"], "41.970634", "-87.760892", true, false),
    new Station("41290", "Kimball", ["Brown"], "41.967901", "-87.713065", true, true),
    new Station("41300", "Loyola", ["Red"], "42.001073", "-87.661061", true, false),
    new Station("41310", "Paulina", ["Brown"], "41.943623", "-87.670907", true, false),
    new Station("41320", "Belmont", ["Brown", "Purple", "Red"], "41.939751", "-87.65338", true, false),
    new Station("41330", "Montrose", ["Blue"], "41.961539", "-87.743574", false, false),
    new Station("41340", "LaSalle", ["Blue"], "41.875568", "-87.631722", false, false),
    new Station("41350", "Oak Park", ["Green"], "41.886988", "-87.793783", false, false),
    new Station("41360", "California", ["Green"], "41.88422", "-87.696234", true, false),
    new Station("41380", "Bryn Mawr", ["Red"], "41.983504", "-87.65884", false, false),
    new Station("41400", "Roosevelt", ["Red", "Green", "Orange"], "41.867368", "-87.627402", true, false),
    new Station("41410", "Chicago", ["Blue"], "41.896075", "-87.655214", false, false),
    new Station("41420", "Addison", ["Red"], "41.947428", "-87.653626", true, false),
    new Station("41430", "87th", ["Red"], "41.735372", "-87.624717", true, false),
    new Station("41440", "Addison", ["Brown"], "41.947028", "-87.674642", true, false),
    new Station("41450", "Chicago", ["Red"], "41.896671", "-87.628176", true, false),
    new Station("41460", "Irving Park", ["Brown"], "41.954521", "-87.674868", true, false),
    new Station("41480", "Western", ["Brown"], "41.966163", "-87.688502", true, false),
    new Station("41490", "Harrison", ["Red"], "41.874039", "-87.627479", false, false),
    new Station("41500", "Montrose", ["Brown"], "41.961756", "-87.675047", true, false),
    new Station("41510", "Morgan", ["Green", "Pink"], "41.885586", "-87.652193", true, false),
    new Station("41660", "Lake", ["Red", "Brown", "Green", "Orange", "Pink", "Purple", "Blue"], "41.884809", "-87.627813", true, false,
        pexp: true, note: "To connect to elevated lines (Brown, Green, Orange, Purple Line Express, and Pink Lines), exit station via Lake-Randolph exit and walk north to State/Lake 'L' station. Farecard required for free transfer to elevated lines."),
    new Station("41670", "Conservatory", ["Green"], "41.884904", "-87.716523", true, false),
    new Station("41680", "Oakton-Skokie", ["Yellow"], "42.02624348", "-87.74722084", true, false)
  ];
}

getStationFromID(String id) {
  if (id.contains("%BUS%")) {
    List<Stop> stops = getStops();
    for (var stop in stops) {
      if (stop.id == id.replaceAll("%BUS%", "")) {
        return stop;
      }
    }
    return stops[0];
  } else {
    List<Station> stations = getStationData();
    for (var station in stations) {
      // Station station = stations[x];
      if (station.id == id) {
        return station;
      }
    }

    return stations[0];
  }
}
