import 'package:flutter/foundation.dart';
import '../models/device.dart';
import '../models/room.dart';
import '../models/session.dart';

class AppController extends ChangeNotifier {
  UserSession? session;

  // Fake users db (demo)
  final List<UserSession> _users = [UserSession(name: "Sujon", email: "sujon@gmail.com")];
  final Map<String, String> _passwords = {"sujon@gmail.com": "123456"};

  // Rooms
  final List<Room> rooms = [
    Room(id: "r1", name: "Living room"),
    Room(id: "r2", name: "Bedroom"),
    Room(id: "r3", name: "Kitchen"),
  ];

  // Devices
  final List<SmartDevice> devices = [
    SmartDevice(id: "d1", name: "Smart Speaker", type: DeviceType.speaker, roomId: "r1"),
    SmartDevice(id: "d2", name: "Thermostat", type: DeviceType.thermostat, roomId: "r2", temperature: 25),
    SmartDevice(id: "d3", name: "Smart Light", type: DeviceType.light, roomId: "r1", isOn: false, brightness: 0.5),
    SmartDevice(id: "d4", name: "WiFi Router", type: DeviceType.router, roomId: "r1", speedMbps: 200),
    SmartDevice(id: "d5", name: "Hall Light", type: DeviceType.light, roomId: "", isOn: true, brightness: 0.3),
  ];

  /* ---------------- AUTH ---------------- */

  Future<String?> login(String email, String password) async {
    final exists = _passwords[email.trim()];
    if (exists == null) return "Account not found";
    if (exists != password) return "Wrong password";

    final u = _users.firstWhere((e) => e.email == email.trim());
    session = UserSession(name: u.name, email: u.email);
    notifyListeners();
    return null;
  }

  Future<String?> register(String name, String email, String password) async {
    final e = email.trim();
    if (_passwords.containsKey(e)) return "Email already exists";
    if (password.length < 6) return "Password must be at least 6 characters";

    final u = UserSession(name: name.trim().isEmpty ? "User" : name.trim(), email: e);
    _users.add(u);
    _passwords[e] = password;

    session = u;
    notifyListeners();
    return null;
  }

  Future<String?> forgotPassword(String email) async {
    if (!_passwords.containsKey(email.trim())) return "No account with this email";
    return null; // demo "link sent"
  }

  void logout() {
    session = null;
    notifyListeners();
  }

  /* ---------------- ROOMS ---------------- */

  void addRoom(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    rooms.add(Room(id: "r${DateTime.now().millisecondsSinceEpoch}", name: trimmed));
    notifyListeners();
  }

  void renameRoom(Room room, String newName) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    room.name = trimmed;
    notifyListeners();
  }

  void deleteRoom(Room room) {
    for (final d in devices) {
      if (d.roomId == room.id) d.roomId = "";
    }
    rooms.removeWhere((r) => r.id == room.id);
    notifyListeners();
  }

  /* ---------------- MAPPING ---------------- */

  void assignDeviceToRoom(SmartDevice device, String roomId) {
    device.roomId = roomId;
    notifyListeners();
  }

  void unassignDevice(SmartDevice device) {
    device.roomId = "";
    notifyListeners();
  }

  List<SmartDevice> devicesInRoom(String roomId) => devices.where((d) => d.roomId == roomId).toList();
  List<SmartDevice> unassignedDevices() => devices.where((d) => d.roomId.isEmpty).toList();

  /* ---------------- CONTROL ---------------- */

  void togglePower(SmartDevice d, bool on) {
    d.isOn = on;
    notifyListeners();
  }

  void setBrightness(SmartDevice d, double v) {
    d.brightness = v.clamp(0, 1);
    notifyListeners();
  }

  void setIntensity(SmartDevice d, double v) {
    d.intensity = v.clamp(0, 1);
    notifyListeners();
  }

  void setVolume(SmartDevice d, double v) {
    d.volume = v.clamp(0, 1);
    notifyListeners();
  }

  void togglePlayback(SmartDevice d) {
    d.playing = !d.playing;
    notifyListeners();
  }

  void setTemperature(SmartDevice d, double v) {
    d.temperature = v.clamp(10, 35);
    notifyListeners();
  }

  void setThermoMode(SmartDevice d, String mode) {
    d.thermoMode = mode;
    notifyListeners();
  }
}
