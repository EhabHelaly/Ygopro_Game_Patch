--Dragonilian Eradication
function c11511245.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511245.target)
	e1:SetOperation(c11511245.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11511245.con)
	e2:SetCost(c11511245.cost)
	e2:SetTarget(c11511245.target2)
	e2:SetOperation(c11511245.activate2)
	c:RegisterEffect(e2)
end
function c11511245.filter1(c,e,tp)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		 and (c:GetSequence()==6 or c:GetSequence()==7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11511245.filter2(c)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c11511245.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
					and Duel.IsExistingTarget(c11511245.filter1,tp,LOCATION_SZONE,0,1,nil,e,tp)
					and Duel.IsExistingTarget(c11511245.filter2,tp,LOCATION_MZONE,0,1,nil) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c11511245.filter1,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c11511245.filter2,tp,LOCATION_MZONE,0,1,1,nil)
    e:SetLabelObject(g1:GetFirst())
end
function c11511245.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
		if Duel.CheckLocation(tp,LOCATION_SZONE,6) then
	    	Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,6)
	    elseif Duel.CheckLocation(tp,LOCATION_SZONE,7) then
	    	Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,7)
	    end

	end
end
function c11511245.filterAtt(c,att)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsAttribute(att)
end
function c11511245.getAttributesNumber(tp)
	local attributes={ATTRIBUTE_WIND,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_DEVINE}
	local count=0
	local att
	for att=1,7 do
		if Duel.IsExistingMatchingCard(c11511245.filterAtt,tp,LOCATION_MZONE,0,1,nil,attributes[att]) then count=count+1 end
	end
	return count
end
---------------------------------------------------
function c11511245.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (e:GetHandler():GetTurnID()~=Duel.GetTurnCount() or e:GetHandler():IsReason(REASON_RETURN))
		and c11511245.getAttributesNumber(tp)>=6
end
function c11511245.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11511245.cfilter(c,att)
	return c:IsSetCard(0xffd) and c:IsFaceup() and c:IsAttribute(att)
end
function c11511245.dfilter1(c)
	return c:IsDestructable() and c:IsFaceup()
end
function c11511245.dfilter2(c)
	return c:IsDestructable() and c:IsFacedown()
end
function c11511245.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		   Duel.IsExistingMatchingCard(c11511245.dfilter1,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.IsExistingMatchingCard(c11511245.dfilter2,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		or Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>0
	end
end
function c11511245.activate2(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c11511245.dfilter1,tp,0,LOCATION_MZONE,1,nil) then
		ops[off]=aux.Stringid(11511247,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c11511245.dfilter2,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(11511247,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=0 then
		ops[off]=aux.Stringid(11511247,2)
		opval[off-1]=3
		off=off+1
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>0 then
		ops[off]=aux.Stringid(11511247,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetMatchingGroup(c11511245.dfilter1,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif opval[op]==2 then
		local g=Duel.GetMatchingGroup(c11511245.dfilter2,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif opval[op]==3 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	elseif opval[op]==4 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
