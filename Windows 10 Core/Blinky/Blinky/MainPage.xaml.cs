using System;
using Windows.Devices.Gpio;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Media;


// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409

namespace Blinky
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        private const int LED_PIN = 5;

        private GpioPin pin;
        private GpioPinValue pinValue;
        private bool hasGpio;

        private DispatcherTimer timer;

        private SolidColorBrush onBrush = new SolidColorBrush(Windows.UI.Colors.Red);
        private SolidColorBrush offBrush = new SolidColorBrush(Windows.UI.Colors.DarkRed);

        private void InitGPIO()
        {
            var gpio = GpioController.GetDefault();

            if (gpio == null)
            {
                pin = null;
                GpioStatus.Text = "There is no GPIO controller on this device.";
                hasGpio = false;
                return;
            }

            pin = gpio.OpenPin(LED_PIN);
            pinValue = GpioPinValue.High;
            pin.Write(pinValue);
            pin.SetDriveMode(GpioPinDriveMode.Output);
            hasGpio = true;

            GpioStatus.Text = "GPIP pin initialized.";
        }

        public MainPage()
        {
            this.InitializeComponent();

            timer = new DispatcherTimer();
            timer.Interval = TimeSpan.FromMilliseconds(500);
            timer.Tick += Timer_Tick;

            InitGPIO();

            timer.Start();
        }

        private void Timer_Tick(object sender, object e)
        {
            if (pinValue == GpioPinValue.High)
            {
                LED.Fill = offBrush;
                pinValue = GpioPinValue.Low;
            }
            else
            {
                LED.Fill = onBrush;
                pinValue = GpioPinValue.High;
            }

            if (hasGpio)
            {
                pin.Write(pinValue);
            }
        }
    }
}
