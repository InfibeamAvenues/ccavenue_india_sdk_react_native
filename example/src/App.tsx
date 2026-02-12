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
        accessCode: 'AVZC42NB40AS14CZSA',
        amount: amount,
        currency: 'INR',
        trackingId: '2130000002076256',
        requestHash:
          '092d8f20e8d97690a8caee826850c857864b2cc79df789099876506f7be3379ec251e19f1cc8e3a1e009d7664f64be00290e1100813aa8822378d258a5e1dd6b',
        appColor: '#164880',
        fontColor: '#FFFFFF',
        paymentType: 'wallet',
        display_promo: 'no',
        displayDialog: 'yes',
        environment: 'qa',
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
