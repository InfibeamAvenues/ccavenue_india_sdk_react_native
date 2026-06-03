import { useState } from 'react';
import {
  StyleSheet,
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ActivityIndicator,
  Modal,
  ScrollView,
  SafeAreaView,
} from 'react-native';
import { payCCAvenue } from 'ccavenue-india-sdk-react-native';

export default function App() {
  const [amount, setAmount] = useState('170.00');
  const [loading, setLoading] = useState(false);
  const [errorText, setErrorText] = useState('');
  const [responseModalVisible, setResponseModalVisible] = useState(false);
  const [responseData, setResponseData] = useState('');

  const initiatePayment = async () => {
    setLoading(true);
    setErrorText('');

    try {
      const order = {
        accessCode: 'AVNU70LC55AY03UNYA',
        encRequest:
          'd80c9885d2a910647967aa64b20cc37db4d8c28d5a98fe2ab47bf1247cf1be0362a42c06223d518fb14c1730ed3e3219555488de487fa60c99f539892e7e1a4882895f565c329d55627cf7036030cc90eb90195c83e41094194240fc9f92622474e225262969da07b60c937f572b6f88b2932906f3d8496a09d0dbd0cdf12420a0cfe52e4f818d42e0fb2b34c051510be3b4caa0b011066d0164856ade7adf57cbae988b1b5b63bddb3e6cc829bb5afbabcd45378693ea6b5bf1a6a5ebdcd5aa0c1aeb666a58c1d56562315f1e96c723bf78a179e0167b8b1f1bcbaade0b201e57887cd6d75d53944ee5c2be3ab9bb217458c5c5f5dc41e97c2ff09210b850d22e5c262dd7a5493e89b4f48f6056bc072d4a512866216712f3878222ad3b260e33790f5684a19e2c01a025258c3c6af7990211e9d3fc564a2ecd5ebb64bcc89299048175162f81f1de805cde6786d2efe89aac7c487bbf4280b14ff4d7802bfe99e23acc2b356499783b74069943888f236901f06dcce066c79c5d3cad071945738ba96804d4ac16fbeccf410cdcbebcb4e63c81f615803077b13c012162f9b3b74e2ec6b0d39434723d4c004576311ad768a88a87ef0216f19bde1e4facdab589ffc34044f3cb7c7a7715cec1823920f5bde0677ce8b7406e2a83096e6c710a0466da54a401383d366a9364f0a8840bfcdfd320e5788cc9ec13a268d56092d006eb664c1d40cd32a4b44438431df060727487f1a2f81cca379f3b434c88bd044a1971aaabc17212fb506fbfdf4bebc04578dafcbe025e76db695c32930ac81f44cc7f61cabb7363fcd79e8fca34302f274abc58a25bb3c733f1a4486b87645ff0c7f856cb659800b4d789937ca32c6a14910b745383c67d58401ca6365ceacae4bb2ad46e1104a27ba8ee4b34068a70c7685f6f847d6317f3fd9316d7af4db6b27deea1d31d4dd5783ffb939f1546848d521f017fe0df09c0991bd00ede9e9ca87835dbdcf3403c66cfda3f5705920550b698f165e16e602cc2f519d8b367680b1b27804421e01eb5d1323a796c29e0a4d817f7fedbd46e912a667cbc9ed4f39c3da8b61192b09cb82ca641d682a95a3138b8023f0d60b12f2df3e619fe998c1ef2b5840f8761b5cf20ce3e545696e1a7b4849de5084210c1b32aa9c78cfd3057b0561a455e4e9884e24e887a087f766dd099c3c0c6050d7c6664f72a7fbd1239c545a0ffd976ecbdd12b8f4c272ca2ed68e560ea408f947da664c828daf3f9d6e197c0102ce25215e14d3de6442a38258b2a908e43624e05db8285cf2835d09d3df0a073b5e45276a9bb1bde9edb8c05c76f9d4fce538cd52e3a9827d16206684b8898752d7effb12dc6b226fa1f685ac1519680d4528d4b2280f1325f2e888bea0050d09267f64eb316288accb6b0db123fc312a7daebf45a2c0275795ea130329732155e7e80599e4a791db1d0579bde915fcc7db39e78993ab1bd0176b4e1639ccc4e8600a17a72088883625f5fc6f80d5351a9283a2911d80d51ef99554582713081c41d5721efbc1e9e7dc9573484a62a197cf86d5624fb38d574840bb8336690e12e5647f423e3a58d43b028fbb5cb9fb8b715481594ade87afeaaf755601abc01f00b866ac42bc98ee4bc4d17669f812897d5cc47e8d577bac6d4d0bef07089d14713b5c6be343e15d555dbacf80d06d54f47b2f2daca205ed19c16431f40f3301399211b85efd4e1cd0714a0b2ca3003fd4380bfc622267455e44dd7cd9af396a0ef6e6db466d8a332570e8063e9be59e19284a170c5c5f9a1a082a6bd4dc26835489fdd7b5824404f169fcdccd9860b860a59580b95fb1426b81a4600895e5e5f6832972ddea822397796',
        appColor: '#164880',
        fontColor: '#FFFFFF',
        paymentEnvironment: 'production',
      };

      // Call the SDK
      const response = await payCCAvenue(order);

      setResponseData(
        JSON.stringify(response, null, 2) || 'No response received'
      );
      setResponseModalVisible(true);
    } catch (e: any) {
      setErrorText(`Error: ${e.message || e}`);
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.appBar}>
        <Text style={styles.appBarTitle}>CCAvenue India SDK</Text>
      </View>

      {loading ? (
        <View style={styles.centerContent}>
          <ActivityIndicator size="large" color="#164880" />
        </View>
      ) : (
        <View style={styles.content}>
          <View style={styles.iconContainer}>
            {/* Simple text icon as placeholder since we don't have vector icons installed by default */}
            <Text style={styles.iconText}>💳</Text>
          </View>

          <View style={styles.inputContainer}>
            <Text style={styles.inputLabel}>Payment Amount</Text>
            <View style={styles.inputWrapper}>
              <Text style={styles.currencySymbol}>₹</Text>
              <TextInput
                style={styles.input}
                value={amount}
                onChangeText={setAmount}
                keyboardType="numeric"
                placeholder="170.00"
              />
            </View>
            {errorText ? (
              <Text style={styles.errorText}>{errorText}</Text>
            ) : null}
          </View>

          <TouchableOpacity style={styles.button} onPress={initiatePayment}>
            <Text style={styles.buttonText}>PROCEED TO PAY</Text>
          </TouchableOpacity>
        </View>
      )}

      <Modal
        visible={responseModalVisible}
        transparent={true}
        animationType="slide"
        onRequestClose={() => setResponseModalVisible(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>CCAvenue SDK Response</Text>
            <ScrollView style={styles.modalScroll}>
              <Text style={styles.responseText}>{responseData}</Text>
            </ScrollView>
            <TouchableOpacity
              style={styles.modalButton}
              onPress={() => setResponseModalVisible(false)}
            >
              <Text style={styles.modalButtonText}>OK</Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  appBar: {
    height: 60,
    backgroundColor: '#164880',
    alignItems: 'center',
    justifyContent: 'center',
  },
  appBarTitle: {
    color: '#fff',
    fontSize: 20,
    fontWeight: 'bold',
  },
  centerContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    flex: 1,
    padding: 20,
    justifyContent: 'center',
  },
  iconContainer: {
    alignItems: 'center',
    marginBottom: 40,
  },
  iconText: {
    fontSize: 80,
    color: '#164880',
  },
  inputContainer: {
    marginBottom: 24,
  },
  inputLabel: {
    fontSize: 12,
    color: '#666',
    marginBottom: 4,
  },
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 12,
    paddingHorizontal: 12,
    height: 56,
  },
  currencySymbol: {
    fontSize: 16,
    color: '#333',
    marginRight: 8,
  },
  input: {
    flex: 1,
    fontSize: 16,
    color: '#333',
  },
  errorText: {
    color: 'red',
    fontSize: 12,
    marginTop: 4,
  },
  button: {
    backgroundColor: '#164880',
    height: 55,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  modalContent: {
    width: '80%',
    backgroundColor: '#fff',
    borderRadius: 8,
    padding: 20,
    maxHeight: '60%',
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  modalScroll: {
    marginBottom: 10,
  },
  responseText: {
    fontFamily: 'monospace',
    fontSize: 12,
  },
  modalButton: {
    alignSelf: 'flex-end',
    padding: 10,
  },
  modalButtonText: {
    color: '#164880',
    fontWeight: 'bold',
  },
});
