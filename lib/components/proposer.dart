class Proposer {
  final String name;
  final String position;
  final String coverLetter;
  final bool isHired;

  Proposer(
      {required this.name,
      required this.position,
      required this.coverLetter,
      required this.isHired});

  static List<Proposer> proposers = [];

  static void addProposer(
      String name, String position, String coverLetter, bool isHired) {
    proposers.add(Proposer(
        name: name,
        position: position,
        coverLetter: coverLetter,
        isHired: isHired));
  }
}
