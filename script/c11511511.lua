--Vortex Immensity
function c11511511.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
    e1:SetTarget(c11511511.tg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c11511511.valcon)
	c:RegisterEffect(e1)
	--be material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetCondition(c11511511.mcon)
	e2:SetOperation(c11511511.mop)
	c:RegisterEffect(e2)
end
function c11511511.filterR(c,race)
	return c:IsRace(race) and c:IsFaceup()
end
function c11511511.tg(e,c)
	return c:IsSetCard(0xffa) and c:IsFaceup() 
	and not Duel.IsExistingMatchingCard(c11511511.filterR,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,c,c:GetRace()) 
end
function c11511511.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c11511511.mcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION and e:GetHandler():GetReasonCard():IsSetCard(0xffa)
end
function c11511511.mop(e,tp,eg,ep,ev,re,r,rp)
	--sp
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(11511511,0))
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11511511.ftg)
	e1:SetOperation(c11511511.fop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c11511511.filterfSP(c,e,tp)
	return c:IsSetCard(0xffa) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11511511.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c11511511.filterfSP,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11511511.fop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511511.filterfSP,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
