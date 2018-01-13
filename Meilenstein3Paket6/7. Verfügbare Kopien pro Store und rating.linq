<Query Kind="Statements">
  <Connection>
    <ID>f8e9a9ac-a4c6-4418-9a02-7c9a93eb3805</ID>
    <Persist>true</Persist>
    <Driver Assembly="IQDriver" PublicKeyToken="5b59726538a49684">IQDriver.IQDriver</Driver>
    <Provider>Devart.Data.MySql</Provider>
    <CustomCxString>AQAAANCMnd8BFdERjHoAwE/Cl+sBAAAApe+jE7mRxEyBm0yNwY96GwAAAAACAAAAAAAQZgAAAAEAACAAAACxqLTEpJ6B3z5a35ALwc7nlc1spyf2xvd4J0tLQUIa5wAAAAAOgAAAAAIAACAAAAAzqTBI/29bpG8M8opU2uFUOwTrDpJ/2txNxS0VYh9wnFAAAAAPFLCPDXxudAtjuo9A5XctG+wmt9+7FI+xn2NWiMpbVsfp1zYfcJ/OZvMnHwAL1ircyXgD3vAsVlxLjo9ZvMdyf0WsyL8c18TJKgP7B7N1N0AAAAAfRXpck38Gxw7T9HUDz0K/1yubT3ZBa2XaHFg6zcM0iQoRTPxj8KG9HCdExcfa6jMLBQiJBsgrhV4UzFjRebxm</CustomCxString>
    <Server>127.0.0.1</Server>
    <UserName>root</UserName>
    <Database>sakila</Database>
    <Password>AQAAANCMnd8BFdERjHoAwE/Cl+sBAAAApe+jE7mRxEyBm0yNwY96GwAAAAACAAAAAAAQZgAAAAEAACAAAAD2F6Axe517GqcOb1Uf3QARQrEela9cGlc8TGrmvc3EEAAAAAAOgAAAAAIAACAAAAA9JIzWm9mb0c60erh2MVgTidWSiKJ3dDmC9dA40qjUOCAAAAAZqUQMgZiH+Y6gjSB57KQlxtl6rCLSmR0wWjH5OZ41+0AAAADnZNAM3BeQRXKCjVmQ86vCHBR5CkHEyXsARkH5awgiAYGZN0gmjADpp86EtLPAe9aLOeVbgaRnJZKm5covSo+5</Password>
    <EncryptCustomCxString>true</EncryptCustomCxString>
    <DriverData>
      <StripUnderscores>false</StripUnderscores>
      <QuietenAllCaps>false</QuietenAllCaps>
    </DriverData>
  </Connection>
</Query>

var verfügbareKopien = 
from f in Films
from i in Inventories

orderby i.Store_id
orderby f.Rating ascending

group new { f,i } by new { f.Rating, i.Store_id } into grp
select new {
grp.First().i.Store_id,
grp.First().f.Rating,
AnzahlKopien = grp.Count()
};

verfügbareKopien.Dump();