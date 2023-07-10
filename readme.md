<!--heading-->
<h1 align="center"><u>Integrating NN in CFD model</u></h1>

<!--description-->
<h2 align="left">Description:</h2>
<p align="justify"><i>Matlab R2022b</i> is used to build the neural network model shown here.The model takes <b>5</b> inputs (x and y position, Reynolds number, Richardson number and Speed ratio) to predict the heat transfer characteristics and pressure drop characteristics of the CFD model I used. Two different types of NN model is used for prediction-<b>ANN</b> and <b>ANFIS</b>. There is also a <b>regression model</b> and <b>decision tree</b> algorithm constructed for the same purpose. The validation parameters R square value, RMSE, and MAPE are used to compare each model to the others at the end. </p>


<!--how to use-->
<h2 align="left">How to use: </h2>
<p align="justify">
<ul>
<li>You need matlab to run the code</li>
<li>Import your data to in data variable</li>
<li>Change the split data funciton according to your total data. For example if your total data is x, .75x (or 75% of your data) must be an integer. If not change the value to 0.8 or accordingly</li>
<li>Change hidden layer number accordingly</li>
</ul>
</p>

<!--credits-->
<h2 align="Left">Credits:</h2>
<p>
<a href="https://github.com/AbidMorshed">Abid Al Morshed</a>
</p>


<!--future update-->

<h2 align="Left">Future Update:</h2>

- [x] Suggest best algorithm for ANN and ANFIS  
- [x] Combine all ANN algorithm in to one  
- [ ] Make ANFIS moduler
- [ ] Combine all output into one
<!--License-->

<h2 align="left">License:</h2>
license.txt

<!--contact-->
<h2 align="Left">Contact:</h2>

<a href="https://www.linkedin.com/in/abidalmorshed/">
<img src="./Images/linkedin.png" width="35"/>
</a>
<a href="https://www.facebook.com/abid.almorshed/">
<img src="./Images/facebook.png" width="35"/>
</a>

<a href="https://mail.google.com/mail/?view=cm&fs=1&to=abidmorshed22@gmail.com">
<img src="./Images/gmail.png" width="32"/>
</a>


<!--all links-->
<!--[linkedin]:https://www.linkedin.com/in/abidalmorshed/
[facebook]:https://www.facebook.com/abid.almorshed/-->