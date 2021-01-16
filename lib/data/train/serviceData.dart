import 'package:CTA_Tracker/pages/serviceInfo/serviceInfo.dart';

List<Table> getServiceData(String line) {
  switch (line) {
    case "Green":
      return [
        new Table("Between Harlem/Lake and Cottage Grove or Ashland/63rd", [
          "Weekdays",
          "Sat.",
          "Sun./Holiday",
        ], [
          "Harlem,Cottage Grove",
          "Cottage Grove,Harlem",
          "Harlem,Ashland/63rd",
          "Ashland/63rd,Harlem"
        ], [
          [
            "4:00a-12:50a",
            "5:00a-12:50a",
            "5:00a-12:50a",
          ],
          [
            "4:05a-1:00a",
            "5:05a-1:00a",
            "5:05a-1:00a",
          ],
          [
            "4:10a-1:05a",
            "5:15a-1:05a",
            "5:15a-1:05a",
          ],
          [
            "3:50a-12:40a",
            "4:50a-12:40a",
            "4:50a-12:40a",
          ]
        ]),
      ];

    case "Purple":
      return [
        new Table("Service between Linden and Howard", [
          "Mon-Thu",
          "Friday",
          "Saturday",
          "Sunday/Holiday",
        ], [
          "Linden,Howard",
          "Howard,Linden",
        ], [
          [
            "4:45a-1:30a",
            "4:50a-2:10a",
            "5:30a-2:15a",
            "6:30a-1:45a",
          ],
          [
            "4:25a-1:10a",
            "4:30a-1:50a",
            "5:05a-1:50a",
            "6:05a-1:20a",
          ]
        ]),
        new Table("Express service between Linden and Downtown", [
          "Mon.-Fri.",
        ], [
          "Linden,Loop",
          "Loop,Linden",
        ], [
          ["5:15a-9:15an2:25p-6:25p"],
          ["5:55a-10:00an3:05p-7:05p"]
        ])
      ];

    case "Orange":
      return [
        new Table("Service Between Midway and Downtown", [
          "Weekdays",
          "Saturday",
          "Sunday/Holiday"
        ], [
          "Midway,Loop",
          "Loop,Midway",
        ], [
          ["3:30a-1:05a", "4:00a-1:05a", "4:30a-1:05a"],
          ["3:50a-1:25a", "4:20a-1:25a", "4:50a-1:25a"]
        ]),
      ];

    case "Pink":
      return [
        new Table("Service Between 54th/Cermak and Downtown", [
          "Weekdays",
          "Saturday",
          "Sunday/Holiday"
        ], [
          "54th/Cermak,Loop",
          "Loop,54th/Cermak",
        ], [
          ["4:00a-1:00a", "5:00a-1:00a", "5:00a-1:00a"],
          ["4:25a-1:25a", "5:25a-1:25a", "5:25a-1:25a"]
        ]),
      ];
    case "Red":
      return [
        new Table("Service Between Howard and 95th/Dan Ryan", [
          "Mon-Fri",
          "Weekends, Holidays"
        ], [
          "Howard,95th",
          "95th,Howard",
        ], [
          [
            "24 hr. service ",
            "24 hr. service",
          ],
          [
            "24 hr. service",
            "24 hr. service",
          ]
        ]),
      ];

    case "Yellow":
      return [
        new Table("Between Dempster-Skokie and Howard", [
          "Weekdays",
          "Saturdays",
          "Sunday/Holiday"
        ], [
          "Dempster-Skokie,Howard",
          "Howard,Dempster-Skokie",
        ], [
          ["5:00a-11:15p", "6:30a-11:15p", "6:30a-11:15p"],
          [
            "4:45a-11:00p",
            "6:15a-11:00p",
            "6:15a-11:00p",
          ]
        ]),
      ];

    case "Blue":
      return [
        new Table("Between O'Hare & Forest Park", [
          "Mon-Fri",
          "Weekends, Holidays"
        ], [
          "O'Hare,Forest Park",
          "Forest Park,O'Hare",
        ], [
          [
            "24 hr. service ",
            "24 hr. service",
          ],
          [
            "24 hr. service",
            "24 hr. service",
          ]
        ]),
      ];
    case "Brown":
      return [
        new Table("Between Kimball and Downtown", [
          "Weekdays",
          "Saturday",
          "Sunday/Holiday"
        ], [
          "Kimball,Loop",
          "Loop,Kimball",
        ], [
          ["4:00a-1:00a", "4:00a-1:00a", "5:00a-1:00a"],
          ["4:30a-1:30a", "4:30a-1:30a", "5:30a-1:30a"]
        ]),
        new Table("Between Kimball and Belmont", [
          "Weekdays",
          "Saturday",
          "Sunday/Holiday"
        ], [
          "Kimball,Belmont",
          "Belmont,Kimball",
        ], [
          ["4:00a-2:00a", "4:00a-2:00a", "5:00a-1:00a"],
          ["5:00a-2:20a", "5:00a-2:20a", "6:00a-2:00a"]
        ]),
      ];
  }
}
