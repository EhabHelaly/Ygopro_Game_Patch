--SW Ally Sanzang
function c11511439.initial_effect(c)
	c:SetUniqueOnField(1,0,11511439)
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsSetCard,0xffb),aux.NonTuner(Card.IsCode,11511427))
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11511439.spcon)
	e1:SetTarget(c11511439.sptg)
	e1:SetOperation(c11511439.spop)
	c:RegisterEffect(e1)
	--battle destroy
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdcon)
	e2:SetTarget(c11511439.tg)
	e2:SetOperation(c11511439.op)
	c:RegisterEffect(e2)
end
function c11511439.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c11511439.mgfilter(c,e,tp,sc,mg,to)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),REASON_SYNCHRO)==REASON_SYNCHRO and c:GetReasonCard()==sc
		and ( (to==LOCATION_HAND and c:IsAbleToHand() ) or (to==LOCATION_MZONE and c:IsCanBeSpecialSummoned(e,0,tp,false,false) ) )
end
function c11511439.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	mg=mg:Filter(aux.NecroValleyFilter(c11511433.mgfilter),nil,e,tp,e:GetHandler(),mg,LOCATION_MZONE)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11511439.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	mg=mg:Filter(aux.NecroValleyFilter(c11511439.mgfilter),nil,e,tp,e:GetHandler(),mg,LOCATION_MZONE)
	if mg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if mg:GetCount()>1 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			mg=mg:Select(tp,1,1,nil)
		end
		if Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP) then 
			mg=e:GetHandler():GetMaterial()
			mg=mg:Filter(aux.NecroValleyFilter(c11511433.mgfilter),nil,e,tp,e:GetHandler(),mg,LOCATION_HAND)
			if mg:GetCount()>0 then
				Duel.SendtoHand(mg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,mg)
			end
		end
	end
end
function c11511439.filter(c)
	return c:IsSetCard(0xffb) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c11511439.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c11511439.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11511439.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function c11511439.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
