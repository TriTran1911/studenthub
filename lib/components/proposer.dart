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

// initial proposers
void initialProposers() {
  Proposer.proposers = [
    Proposer(
        name: 'Alex Jor',
        position: 'Software Engineer',
        coverLetter: 'I am a software engineer with 5 years of experience',
        isHired: false),
    Proposer(
        name: 'John Doe',
        position: 'Data Scientist',
        coverLetter: 'I am a data scientist with 3 years of experience',
        isHired: false),
    Proposer(
        name: 'Jane Doe',
        position: 'Product Manager',
        coverLetter: 'I am a product manager with 7 years of experience',
        isHired: false),
    Proposer(
        name: 'Alex Jor',
        position: 'Software Engineer',
        coverLetter: 'I am a software engineer with 5 years of experience',
        isHired: false),
    Proposer(
        name: 'John Doe',
        position: 'Data Scientist',
        coverLetter: 'I am a data scientist with 3 years of experience',
        isHired: false),
    Proposer(
        name: 'Jane Doe',
        position: 'Product Manager',
        coverLetter: 'I am a product manager with 7 years of experience',
        isHired: false),
  ];
}