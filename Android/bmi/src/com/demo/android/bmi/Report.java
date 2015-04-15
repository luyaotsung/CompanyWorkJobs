package com.demo.android.bmi;

import java.text.DecimalFormat;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;


public class Report extends Activity {
	@Override	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.report);
		
		findView();
		showResults();
		setListensers();

	}
	
	private Button button_back;
	private TextView view_result;
	private TextView view_suggestion;
	
	private void findView(){
		button_back = (Button) findViewById(R.id.report_Back);
		view_result = (TextView) findViewById(R.id.Result);
		view_suggestion = (TextView) findViewById(R.id.Suggesion);
 	}
	
	private void setListensers(){
		button_back.setOnClickListener(backMain);
	}
	
	private Button.OnClickListener backMain = new Button.OnClickListener() {
		public void onClick(View v) {
			Report.this.finish();
		}		
	};
	
	private void showResults() {
					
		try {
			DecimalFormat nf = new DecimalFormat("0.00");
			Bundle bunde = Report.this.getIntent().getExtras();
			
			
			double height = Double.parseDouble(bunde.getString("KEY_HEIGHT")) / 100;
			double weight = Double.parseDouble(bunde.getString("KEY_WEIGHT"));
			double BMI = weight / (height * height);

			view_result.setText(getText(R.string.advice_bmi_result) + nf.format(BMI) );
			
			if (BMI > 25) {
				showNotification(BMI);
				view_suggestion.setText(R.string.advice_heavy);
			} else if (BMI < 20) {
				view_suggestion.setText(R.string.advice_light);
			} else {
				view_suggestion.setText(R.string.advice_average);
			}
		}catch(Exception obj){
			Toast.makeText(getApplication(), R.string.report_Error , Toast.LENGTH_SHORT).show();
		}
	}	
	private void showNotification (double BMI){
		NotificationManager barManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
		
		Notification barMsg = new Notification(
				android.R.drawable.stat_sys_warning,
				"哦,你(妳)該減肥囉!",
				System.currentTimeMillis()
			);
		
		PendingIntent contentIntent = PendingIntent.getActivity(
				getApplicationContext(), 
				0, 
				new Intent(Report.this, BmiActivity.class), 
				PendingIntent.FLAG_UPDATE_CURRENT
			);
		
		barMsg.setLatestEventInfo(
				getApplicationContext(), 
				"你(妳)的BMI值過高", 
				"通知監督人", 
				contentIntent
			);
	
		barManager.notify(0, barMsg);
		
	}
}
