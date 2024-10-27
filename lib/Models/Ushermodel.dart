class Employee {
  final String id;
  final String name;
  final String age;
  final String email;
  final String password;
  final String role;

  Employee({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.password,
    required this.role,
  });

  // Convert a DocumentSnapshot into an Employee model
  factory Employee.fromFirestore(Map<String, dynamic> data, String id) {
    return Employee(
      id: id,
      name: data['name'] ?? '',
      age: data['Age'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? '',
    );
  }

  // Convert Employee model to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'Age': age,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
